#!/usr/bin/env python

"""
Tests correctness of the properties injested by Properties class
    - Use properties generator to randomly generate properties (then write to file)
    - Use Properties class to read the properties
    - Compare the read values with the generator source
"""

import os
import random
import filecmp

from properties import Properties

from test_constants import *
from test_properties import TestProperties

print "TEST_TMP_FOLDER: " + TEST_TMP_FOLDER

class PropertiesTest:
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

def is_same(file_a, file_b):
    return filecmp.cmp(file_a, file_b, shallow=False)
    
if __name__ == '__main__':
    PropertiesTest().run()
