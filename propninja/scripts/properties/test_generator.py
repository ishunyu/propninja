import string
import random

KEY_CHARS = string.ascii_uppercase + string.ascii_lowercase + string.digits + "--..__"
VALUE_CHARS = KEY_CHARS + " "

def randomWord(chars, length):
	return ''.join(random.choice(chars) for _ in range(int(random.betavariate(2, 5) * length)))

# Java Properties File Generator

class JavaPropertiesFileGenerator:
	def generate(self, numOfProperties = 5, numOfComments = 1, avgLinesPerComment = 3):
		self.assertParameters(numOfProperties)

		properties = self.doGenerate(numOfProperties)
		return self.write(properties)

	def assertParameters(self, numOfProperties):
		if numOfProperties < 0:
			raise Exception()	

	def doGenerate(self, numOfProperties):
		properties = {}
		while len(properties) < numOfProperties:
			properties[self.key()] = self.value()
		
		return properties	

	def key(self):
		return randomWord(KEY_CHARS, 50)
	
	def value(self):
		return randomWord(VALUE_CHARS, 100)

	def write(self, properties):
		output = ""
		for k, v in properties.items():
			output += "=".join([k, v]) + "\n"
		return output
