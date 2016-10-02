class PropertiesItem(object):
    def __init__(self):
        self.prev = None
        self.next = None

class Comment(PropertiesItem):
    def __init__(self, lines):
        super(Comment, self).__init__()
        self.lines = lines

    def add(self, line):
        self.lines.add(line)

    def is_data(self):
        return False

    def __str__(self):
        return "\n".join(self.lines)

NORMALIZED=""
class Property(PropertiesItem):
    def __init__(self, wsKey, key, wsAssigner, assigner, elements, nkey=None, nelement=None):
        super(Property, self).__init__()
        self._wsKey = wsKey
        self._key = key
        self._nkey = nkey
        self._wsAssigner = wsAssigner
        self._assigner = assigner
        self._elements = elements
        self._nelement = nelement

    def __str__(self):
        elementStr = "\n".join(["".join(element) for element in self._elements])
        return "".join([self._wsKey, self._key, self._wsAssigner, self._assigner, elementStr])

    def is_data(self):
        return True

    def key(self):
        if self._nkey == NORMALIZED:
            return self._key
        if not self._nkey:
            return self._normalize_key()
        return self._nkey
        
    def value(self):
        if self._nelement == NORMALIZED:
            return self._elements[0][1]
        if not self._nelement:
            self._nelement = self._normalize_element(self._elements)
            if self._nelement == NORMALIZED:
                return self._elements[0][1]
        return self._nelement

    def set(self, value):
        self._elements = [["", value]]
        self._nelement = None

    def _normalize_key(self):
        _key = self._normalize(self._key)
        self._nkey = NORMALIZED if _key == self._key else _key
        return _key

    def _normalize_element(self, elements):
        elementsLen = len(elements)
        if elementsLen == 1:
            element = elements[0][1]
            _element = self._normalize(element)
            self._nelement = NORMALIZED if _element == element else _element
            return _element

        element = "".join([x[:-1] for x in elements[:-1]]) + elements[-1]
        self._nelement = self._normalize(element)
        return self._nelement

    def _normalize(self, chars):
        _chars = ""
        escape = False
        for i, c in enumerate(chars):
            if escape:
                _chars += c
                escape = False
            elif c == "\\":
                escape = True
            else:
                _chars += c

        return _chars
