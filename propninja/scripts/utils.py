# Utilities

def int_str(val):
  return "".join([chr((val & (0xff << pos*8)) >> pos*8) for pos in range(8)])

def str_int(bytes):
  val = 0

  for i, b in enumerate(bytes):
    val |= ord(b) << (i * 8)

  return val

def _recv(s, size):
  d = ""
  while len(d) < size:
    _d = s.recv(size - len(d))
    if not _d:
      return None

    d += _d

  return d

def recv(s):
  _size = _recv(s, 8) # First 8 bytes represent size in signed long
  if not _size:
    return None

  size = str_int(_size)

  if size:
    return _recv(s, size)

  return ""

def send(s, d):
  s.send(int_str(len(d)))

  if len(d):
    s.send(d)

def to_file(path, s):
  with open(path, "w") as f:
    f.write(str(s))

def write_property_file(property_file):
  to_file(property_file.filename, property_file)

def process_active(pid):
  import os
  try:
    os.kill(pid, 0)
    return True
  except OSError:
    return False
