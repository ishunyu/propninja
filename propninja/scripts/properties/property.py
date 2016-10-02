class PropertiesItem(object):
	self.prev = None
	self.next = None

class Comment(PropertiesItem):
	def __init__(self, lines):
		self.lines = lines

	def add(self, line):
		self.lines.add(line)

	def __str__(self):
        return "\n".join(self.lines)

NORMALIZED=""
class Property(object):
    def __init__(self, wsKey, key, wsAssigner, assigner, elements, key_=None, element_=None):
    	self.wsKey = wsKey
    	self.key = key
    	self.key_ = key_
    	self.wsAssigner = wsAssigner
    	self.assigner = assigner
    	self.elements = elements
    	self.element_ = element_

    def __str__(self):
    	elementStr = "\n".join(["".join(element[0], element[1]) for element in self.elements])
        return "".join([self.wsKey, self.key, self.wsAssigner, self.assigner, elementStr])

    def key(self):
        if self.key_ == NORMALIZED:
        	return self.key
        if not self.key_:
        	return self._normalize_key()
        return self.key_
        
    def value(self):
        if self.element_ == NORMALIZED:
            return self.elements[0][1]
        if not self.element_:
        	self.element_ = self._normalize_element(self.elements)
        	if self.element_ == NORMALIZED
        		return self.elements[0][1]
        return self.element_

    def set(self, value):
        self.elements = [["", value]]
        self.element_ = None

    def _normalize_key(self):
    	_key = self._normalize(self.key)
    	self.key_ = NORMALIZED if _key == self.key else _key
    	return _key

    def _normalize_element(self, elements):
    	elementsLen = len(elements)
    	if elementsLen == 1:
    		element = elements[0][1]
    		_element = self._normalize(element)
    		self.element_ = NORMALIZED if _element == element else _element
    		return _element

    	element = "".join([x[:-1] for x in elements[:-1]]) + elements[-1]
    	self.element_ = self._normalize(element)
    	return self.element_

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
