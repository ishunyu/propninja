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