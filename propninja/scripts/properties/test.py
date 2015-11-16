#!/usr/bin/env python
from os import path as ospath
import random
import filecmp

from properties import Properties
from test_generator import JavaPropertiesFileGenerator

TEST_RESOURCE_FOLDER = ospath.join("resource", "test")
TEST_INPUT_FILE = ospath.join(TEST_RESOURCE_FOLDER, "a.in.properties")
TEST_OUTPUT_FILE = ospath.join(TEST_RESOURCE_FOLDER, "a.out.properties")

NUM_MIN_PROPERTIES = 10
NUM_MAX_PROPERTIES = 200
NUM_PROPERTIES = random.randint(NUM_MIN_PROPERTIES, NUM_MAX_PROPERTIES)

print "TEST_RESOURCE_FOLDER: " + TEST_RESOURCE_FOLDER
print "TEST_INPUT_FILE: " + TEST_INPUT_FILE
print "TEST_OUTPUT_FILE: " + TEST_OUTPUT_FILE

def is_same(file_a, file_b):
	return filecmp.cmp(file_a, file_b, shallow=False)

def open_props(fname):
  with open(fname, "r") as f:
    return Properties(f)

def write(obj, fname):
	with open(fname, "w") as f:
  		f.write(str(obj))

def test(input_path, output_path):
	generator = JavaPropertiesFileGenerator()
	input_file = generator.generate(numOfProperties = NUM_PROPERTIES)
	write(input_file, input_path)

	props = open_props(input_path)
	write(props, output_path)

	assert is_same(input_path, output_path)

test(TEST_INPUT_FILE, TEST_OUTPUT_FILE)
