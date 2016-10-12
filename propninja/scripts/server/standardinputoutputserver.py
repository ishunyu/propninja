#!/usr/bin/env python

import os
import sys
import time
import json
from datetime import datetime

import utils
from properties.properties import Properties
from indexer.indexer import PropertyIndexer

sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 1)

class RequestHandler:
  def __init__(self, server):
    self.server = server

  def handle(self, obj):
    return self._handle(obj)

  def _handle(self, req_obj):
    cmd_type = req_obj["type"]
    f = req_obj["file"] if ("file" in req_obj.keys()) else None
    key = req_obj["key"] if ("key" in req_obj.keys()) else None
    value = req_obj["value"] if ("value" in req_obj.keys()) else None

    if cmd_type == "search":
      return self.search(key)

    if cmd_type == "set":
      return self.set(f, key, value)

    if cmd_type == "get":
      return self.get(value)

    if cmd_type == "status":
      return { "value": "ready" }

    if cmd_type == "index":
      return self.index(value)

    if cmd_type == "stop":
      self.server.stop()

  def get(self, propertiesRequest):
    ans = []
    for r in propertiesRequest:
      p = self.getProperty(r[0], r[1])
      if p:
        ans.append(p)

    return {
      "value": ans
    }

  def getProperty(self, f, key):
    property_files = self.server.property_files

    if not f in property_files.keys():
      return

    property_file = property_files[f]

    if not key in property_file.keys():
      return

    return [f, key, property_file[key]]

  def search(self, key):
    search_result = self.server.indexer.search(key)
    property_files = self.server.property_files

    ans = []
    for item in search_result:
      _f = item["file"]
      _key = item["key"]
      _val = property_files[_f][_key]
      ans.append((_f, _key, _val))

    return {
      "key": key,
      "value": ans
    }

  def set(self, f, key, value):
    property_file = self.server.property_files[f]
    property_file[key] = value

    utils.write_property_file(property_file)

    return self.server.SUCCESS

  def index(self, config):
    self.server.index(config)
    return self.server.SUCCESS

class Server:
  def __init__(self, logfiledirpath):
    self._initlogging(logfiledirpath)
    self.SUCCESS = {
      "key": "status",
      "value": True
    }

  def run(self):
    # Signal ready
    self._writesuccess() 

    while True:
      self._write(RequestHandler(self).handle(self._read()))

  def stop(self):
    self._stoplogging()
    self._writesuccess()
    sys.exit(0)

  def _read(self):
    line = sys.stdin.readline()
    line = line.rstrip()
    self._log(line)

    return json.loads(line)

  def _write(self, obj):
    data = json.dumps(obj)
    self._log(data)
    data = data + "\n"
    sys.stdout.write(data)

  def _writesuccess(self):
    self._write(self.SUCCESS)
      
  def index(self, config):
    self.config = config
    self.property_files = self._create_property_files(self.config)
    self.indexer = self._create_indexer(self.property_files)

  def _create_property_files(self, config):
    property_files = {}
    for item in config:
      self._create_property_file(property_files, item)
    return property_files

  def _create_property_file(self, property_files, item):
    if not os.path.exists(item):
      return

    try:
      with open(item, "r") as f:
        property_files[item] = Properties(f)
    except IOError, e:
      # print e
      return

  def _create_indexer(self, property_files):
    docs = []
    for property_file_key in property_files.keys():
      property_file = property_files[property_file_key]

      for prop_key in property_file.keys():
        docs.append((property_file_key, prop_key))

    return PropertyIndexer(docs)

  def _log(self, logline):
    if self.logfile:
      self.logfile.write(str(datetime.now()) + " " + str(logline) + "\n")

  def _initlogging(self, logdirpath):
    if logdirpath:
      if not os.path.exists(logdirpath):
        os.makedirs(logdirpath)

      logfilepath = os.path.join(logdirpath, "standardinputouputserver.log")
      self.logfile = open(logfilepath, "w", 1)

  def _stoplogging(self):
    self.logfile.close()
    self.logfile = None

def main(args):
  Server(args[1]).run()

if __name__ == '__main__':
  main(sys.argv)