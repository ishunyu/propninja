from utils.fileinput import File, Reader
from utils import parse

class Iterator(object):
    def __init__(self, p):
        self.curr = p

    def __iter__(self):
        return self

    def next(self):
        while self.curr:
            tmp = self.curr
            self.curr = self.curr.next
            if tmp.is_data():
                return tmp
        raise StopIteration()

class Properties(object):
    def __init__(self, pFile):
        self.filename = pFile.name
        self.root = parse.parse(Reader(File(pFile)))

    def __iter__(self):
        return Iterator(self.root)

    def __getitem__(self, key):
        item = self._get(key)
        if item:
            return item.real_value()

    def __setitem__(self, key, value):
        item = self._get(key)
        if item:
            item.set(value)

    def __str__(self):
        return "\n".join([str(item) for item in self._all_items()])

    def __len__(self):
        length = 0
        for _ in self:
            length = length + 1

        return length

    def _all_items(self):
        curr = self.root
        while curr:
            tmp = curr
            curr = curr.next
            yield tmp

    def keys(self):
        return [item.key() for item in self]

    def _get(self, k):
        for entry in self:
            if entry.key() == k:
                return entry
