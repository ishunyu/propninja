#!/usr/bin/env python

COMMENT_CHARS = VALUE_CHARS
COMMENT_DELIMITER = "#"

# Format
# <1>key<2>=(<3>value)+<4>comment
# <1>: space to the left of key
# <2>: space to the right of key
# <3>: spaces to the left of each line/segment of value
# <4>: space to the left of comment
class PropertyFormatter:
	def __init__(self, _1, _2, _3, _4):
		self._1 = _1
		self._2 = _2
		self._3 = _3
		self._4 = _4

	def format(self, _key, _value, _comment):
		return self._s(self._1) + _key + self._s(self._2) + "=" + self._c(_value) + self._s(self._4) + _comment

	def _s(self, num):
		if num < 0:
			return ''
		
		# TODO: Upper bound check
		return ' ' * num

	def _c(self, _value):
		if not self._3:
			return _value

		value_len = len(_value)

		if value_len == 0:
			return self._3[0][0]

		value_used = 0
		out_value = ""
		for (left_space, length) in self._3:
			if value_used + length > value_len:
				out_value = self._s(left_space) + _value[value_used:]
				break

			out_value = self._s(left_space) + _value[value_used:value_used+length] + "\\" + "\n";
			value_used = value_used + length

		return out_value


class Property:
	def __init__(self, _key, _value, _comment, _formatter):
		self._key = _key
		self._value = _value
		self._comment = _comment
		self._formatter = _formatter

	def __str__(self):
		if not self._formatter:
			return self._key + '=' + self._value + self._comment

		return self._formatter.format(self._key, self._value, self._comment)

	def key(self):
		return self._key

	def value(self):
		return self._value

	def comment(self):
		return self._comment

