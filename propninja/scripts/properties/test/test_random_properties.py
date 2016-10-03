#!/usr/bin/env python

"""
Properties generator for testing
    - Allow for generation of simple properties without formatting
        - All single line properties
        - No comments, no line breaks within properties
        - -> key<delimiter>value
"""

import string
import random

VALID_CHARS_FOR_PROPERTY_KEY = string.ascii_uppercase + string.ascii_lowercase + string.digits + "--..__"
VALID_CHARS_FOR_PROPERTY_VALUE_FIRST_CHAR = VALID_CHARS_FOR_PROPERTY_KEY
VALID_CHARS_FOR_PROPERTY_VALUE = VALID_CHARS_FOR_PROPERTY_KEY + " "

# Returns a number between 0 and lengthUpperBound inclusive based on a betavariate distribution
def randLength(lengthUpperBound):
    return int(random.betavariate(2, 5) * lengthUpperBound)

# Returns a word of length composed of chararacters selected from chars based on a uniform distribution
def randWord(chars, length):
    return ''.join(random.choice(chars) for _ in range(length))

"""
Test Properties 
    - Accepts an upperbound on the number of properties to be generated
        - This is the maximum number of properties that will be generated
    - self[key] will return the value for the given key, if any
    - len(self) will return the number of properties    
    - str(self) will return a file representation of the properties (which could then be written to files)
    - iter(self) will return self, which yields each property as (key, value) until the end of list
"""
class TestProperties:
    class Iterator:
        def __init__(self, props):
            self.props = props
            self.curr = -1

        def next(self):
            self.curr = self.curr + 1
            if self.curr > len(self.props) - 1:
                raise StopIteration()

            prop = self.props[self.curr]
            return (prop[0], prop[1])

    def __init__(self, numOfPropsUpperBound = 20, probOfEqualSign = 0.75):
        self._init_args(numOfPropsUpperBound, probOfEqualSign)
        self._gen()

    def _init_args(self, numOfPropsUpperBound, probOfEqualSign):
        if numOfPropsUpperBound < 0:
            raise Exception("numOfPropsUpperBound cannot be less than 0. (numOfPropsUpperBound: %s)" % (numOfPropsUpperBound, ))

        if probOfEqualSign < 0.0 or probOfEqualSign > 1.0:
            raise Exception("probOfEqualSign cannot be less than 0.0 or greater than 1.0. (probOfEqualSign: %s)" % (probOfEqualSign, ))

        self.numOfPropsUpperBound = numOfPropsUpperBound
        self.numOfProps = numOfPropsUpperBound
        self.probOfEqualSign = probOfEqualSign

    def _gen(self):
        props = []
        index = {}
        while len(props) < self.numOfProps:
            prop = self._genProp();
            key = prop[0]
            if key in index.keys():
                continue
            props.append(prop)
            index[key] = prop
        
        self.props = props
        self.index = index

    def _genProp(self):
        key = self._genKey()
        value = self._genValue()
        delimiter = self._genDelimiter()
        
        return (key, value, delimiter)

    def _genKey(self):
        return randWord(VALID_CHARS_FOR_PROPERTY_KEY, randLength(49) + 1)
    
    def _genValue(self):
        length = randLength(100)
        if length is 0:
            return ""
        if length is 1:
            return randWord(VALID_CHARS_FOR_PROPERTY_VALUE_FIRST_CHAR, 1)
        return randWord(VALID_CHARS_FOR_PROPERTY_VALUE_FIRST_CHAR, 1) + randWord(VALID_CHARS_FOR_PROPERTY_VALUE, length - 1)

    def _genDelimiter(self):
        # 0.0 -> 0
        # 1.0 -> 100
        if random.randint(1, 100) <= self.probOfEqualSign * 100:
            return "="
        return " "

    def __getitem__(self, k):
        item = self.index[k]
        if not item:
            return None
        return item[1]

    def __iter__(self):
        return TestProperties.Iterator(self.props)

    def __len__(self):
        return len(self.props)

    def __str__(self):
        return "".join([d.join([k, v]) + "\n" for (k, v, d) in self.props])[:-1]


class RandomPropertiesTest:
    def __init__(self, testFileName="test.properties", minNumOfProps=10, maxNumOfProps=200):
        self.testFilePath = os.path.join(TEST_TMP_FOLDER, testFileName)
        self.numOfProps = random.randint(minNumOfProps, maxNumOfProps)

        if not os.path.exists(TEST_TMP_FOLDER):
            os.makedirs(TEST_TMP_FOLDER)
            pass

        if os.path.exists(self.testFilePath):
            os.remove(self.testFilePath)
            pass

    def run(self):
        testProps = TestProperties(self.numOfProps)
        self._write(testProps)
        props = self._read()
        self._validate(testProps, props)

    def _write(self, obj):
        with open(self.testFilePath, "w") as f:
            f.write(str(obj))

    def _read(self):
        with open(self.testFilePath, "r") as f:
            return Properties(f)

    def _validate(self, testProps, props):
        assert len(testProps) == len(props)
        for testProp in testProps:
            propKey, testPropValue = testProp
            propValue = props[propKey]

            if not testPropValue == propValue:
                print "propKey", propKey
                print "testPropValue", testPropValue
                print "propValue", propValue

if __name__ == '__main__':
    testProps = TestProperties()

    for x in testProps:
        print str(x)

    print str(testProps)