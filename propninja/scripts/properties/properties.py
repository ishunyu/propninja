import re

def clean(line):
  line = line.strip()

  if not line:
    return ""

  if line[0] == "#" or line[0] == "!":
    return ""

  match = re.search(r'[^\\](#)', line)

  if match is None:
    return line

  return line[:match.start(1)].rstrip()

class File(object):
  def __init__(self, f):
    line = f.read()
    self.lines = [l.rstrip('\n') for l in line.splitlines()]

    if line and line[-1] == '\n':
      self.lines.append("")

  def __getitem__(self, key):
      return self.lines.__getitem__(key)

  def __len__(self):
    return len(self.lines)

  def __str__(self):
    s = ""
    for l in self.lines:
      s += l
    return s

class Reader(object):
  def __init__(self, f):
    self.i = -1
    self.f = f

  def __getitem__(self, key):
    return self.f.__getitem__(key)

  def prev(self):
    if self.has_prev():
      self.i -= 1
      return self.f[self.i]

    raise Exception()

  def curr(self):
    if self.i == -1:
      raise Exception()

    return self.f[self.i]

  def peek(self):
    if self.has_next():
      return self.f[self.i+1]

    raise Exception()

  def next(self):
    if self.has_next():
      self.i += 1
      return self.f[self.i]

    raise Exception()

  def where(self):
    return self.i

  def has_prev(self):
    return 0 < self.i

  def has_next(self):
    return self.i < len(self.f) - 1

class Property(object):
  def __init__(self, lines, data=True):
    self.prev = None
    self.next = None
    self.data = data
    self.lines = lines

    if data:
      self._assert()

  def __str__(self):
    return "\n".join(self.lines)

  def _assert(self):
    if not self.lines:
      raise Exception()

    i = self._separator_index(self._merged())

    if i == -1:
      raise Exception(self._merged())

  def key(self):
    if self.data:
      return self._key_value()[0]

    return None

  def value(self):
    if self.data:
      return self._key_value()[1]

    return None

  def set(self, value):
    if self.data:
      merged = self._merged()
      i = self._separator_index(merged)

      new_merged = merged[:i+1] # include separator
      new_merged += value

      self.lines = new_merged.split("\n")

  def _key_value(self):
    if self.data:
      merged = self._merged()
      i = self._separator_index(merged)
      return (merged[:i].strip(), merged[i+1:].strip())

    return None

  # Min property has to have one character key and one separator
  def _separator_index(self, line):
    seenKey = False
    for i in range(len(line)):
      x = line[i]
      if x in ['=', ':']:
        if seenKey:
          return i
        else:
          raise Exception(line)
      elif x in [' ', '\t']:
        if seenKey:
          return i
        else:
          continue
      seenKey = True

    return -1

  def _clean(self, line):
    line = clean(line)

    if line[-1] == "\\":
      line = line[:-1].strip()

    return line

  def _merged(self):
    if len(self.lines) == 1:
      return clean(self.lines[0])

    return " ".join([self._clean(line) for line in self.lines])


class Iterator(object):
  def __init__(self, p):
    self.curr = p

  def __iter__(self):
    return self

  def next(self):
    if not self.curr:
      raise StopIteration()

    old = self.curr
    self.curr = self.curr.next
    return old

class Properties(object):
  def __init__(self, propFile):
    self.filename = propFile.name
    f = File(propFile)
    r = Reader(f)
    self.root = self._parse(r)

  def __iter__(self):
    return Iterator(self.root)

  def __getitem__(self, key):
    entry = self._get(key)
    if entry:
      return entry.value()

  def __setitem__(self, key, value):
    item = self._get(key)
    if item:
      item.set(value)

  def __str__(self):
    return "\n".join([str(entry) for entry in self])

  def __len__(self):
    length = 0
    for entry in self:
      if entry.data:
        length = length + 1

    return length

  def keys(self):
    keys = []
    for p in self:
      if p.data:
        keys.append(p.key())

    return keys

  def _get(self, key):
    for entry in self:
      if entry.key() == key:
        return entry

  def _parse(self, r):
    root = None
    prev = None

    while r.has_next():
      entry = self._parse_entry(r)
      if entry:

        if root is None:
          root = entry

        if prev:
          prev.next = entry

        entry.prev = prev
        prev = entry

    return root

  def _parse_entry(self, r):
    line = r.next()
    line = clean(line)

    if self._is_whitespace_or_comments(line):
      return self._parse_whitespace_and_comments(r)

    return self._parse_property(r, line)

  def _is_whitespace_or_comments(self, line):
    return not line

  def _parse_whitespace_and_comments(self, r):
    start = r.where()

    while r.has_next():
      line = r.peek()
      line = clean(line)

      if self._is_whitespace_or_comments(line):
        r.next()
        continue

      break

    lines = r[start:r.where()+1]
    return Property(lines, False)

  def _is_multiline_property(self, line):
    return line[-1] == "\\"

  def _parse_property(self, r, line):
    if self._is_multiline_property(line):
      return self._parse_multiline_property(r)

    return Property(r[r.where():r.where()+1])

  def _parse_multiline_property(self, r):
    start = r.where()

    while r.has_next():
      next_line = r.peek()
      next_line = clean(next_line)

      if self._is_whitespace_or_comments(next_line):
        break

      r.next() # advance because it's going to be part of this property
      line = next_line # next_line becomes current line
        
      # depending on what the next line is, we will continue to accumulate this property
      if self._is_multiline_property(line):  
        continue

      # or skip
      break

    return Property(r[start:r.where()+1])





