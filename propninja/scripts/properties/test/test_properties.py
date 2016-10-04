#!/usr/bin/env python

"""
Run under project root
    python -m unittest test.test_properties

Tests correctness of the properties injested by Properties class
    - Injest .properties files from TEST_RESOURCE_DIR
    - Injest respective .expected files
    - Compare the values with expected
    - Write out Properties to TEST_TMP_DIR
    - Compare the output file with the original
"""

import os
import random
import filecmp
import unittest

from properties.properties import Properties
from constants import *
from utils import *

class TestProperties(unittest.TestCase):
    def setUp(self):
        print "cwd:", os.getcwd()
        print "TEST_RESOURCE_DIR:", TEST_RESOURCE_DIR
        print "isdir:", os.path.isdir(TEST_RESOURCE_DIR)
        _, _, files = next(os.walk(TEST_RESOURCE_DIR))
        self.properties_files = [f for f in files if f.endswith(".properties")]

    def test_properties(self):
        for f in self.properties_files:
            fpath = os.path.join(TEST_RESOURCE_DIR, f)
            props = read(fpath)
            expected = readExpected(fpath + ".expected")
            
            self.assertEqual(len(expected), len(props))

            for k, v in expected.iteritems():
                self.assertEqual(v, props[k], "k: '%s', v: '%s', props[k]: '%s'" % (k, v, props[k]))

            pfpath = os.path.join(TEST_TMP_DIR, f)
            write(pfpath, props)

            is_same(fpath, pfpath)