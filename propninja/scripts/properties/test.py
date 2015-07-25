#!/usr/bin/env python
from properties import Properties

def open_props(fname):
  with open(fname, "r") as f:
    return Properties(f)

props = open_props("a.properties")


with open("a.out.properties", "w") as f:
  f.write(str(props))
