import re
from fileinput import File, Reader
import parse


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
        self.root = parse.parse(Reader(File(propFile)))

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
