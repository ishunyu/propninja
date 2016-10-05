#!/usr/bin/env python

import os
import sys
import time
import json
import threading
import SocketServer
from threading import Thread

import utils
from properties.properties import Properties
from indexer.indexer import PropertyIndexer

current_dir_path = os.path.dirname(os.path.realpath(__file__))

def watch(s):
  while True:
    ppid = os.getppid()
    if not utils.process_active(ppid):
      os._exit(0)

    time.sleep(2)

class RequestHandler(SocketServer.BaseRequestHandler):
  def _handle(self, req_obj):
    cmd_type = req_obj["type"]
    f = req_obj["file"] if ("file" in req_obj.keys()) else None
    key = req_obj["key"] if ("key" in req_obj.keys()) else None
    value = req_obj["value"] if ("value" in req_obj.keys()) else None

    # print cmd_type, key, value

    if cmd_type == "get":
      return self.get(f, key, value)

    if cmd_type == "search":
      return self.search(key)

    if cmd_type == "set":
      return self.set(f, key, value)

    if cmd_type == "status":
      return { "value": "ready" }

    if cmd_type == "index":
      return self.index(value)

    if cmd_type == "stop":
      os._exit(0)

  def get(self, f, key, value):
    property_files = self.server.property_files

    if not f in property_files.keys():
      return

    property_file = property_files[f]

    if not key in property_file.keys():
      return

    return {
      "file": f,
      "key": key,
      "value": property_files[f][key]
    }

  def search(self, key):
    search_result = self.server.indexer.search(key)
    property_files = self.server.property_files

    ans = []
    for item in search_result:
      f = item["file"]
      key = item["key"]
      value = property_files[f][key]
      ans.append((f, key, value))

    return {
      "key": key,
      "value": ans
    }

  def set(self, f, key, value):
    property_file = self.server.property_files[f]
    property_file[key] = value

    utils.write_property_file(property_file)

  def index(self, config):
    self.server.index(config)

  def handle(self):
    while True:
      req_data = utils.recv(self.request)
      if not req_data:
        break

      req_obj = json.loads(req_data)
      resp_obj = self._handle(req_obj)
        
      if resp_obj:
        resp_data = json.dumps(resp_obj)
        utils.send(self.request, resp_data)

    self.request.close()


class ThreadedTCPServer(SocketServer.ThreadingTCPServer):
  def __init__(self, RequestHandlerClass, port, lockFile):
    self._create_watcher()

    self.port = port
    addr = ("", port)
    SocketServer.TCPServer.__init__(self, addr, RequestHandlerClass)

    print "Started..." + str(port)

    open(lockFile, 'w').close()

  def _create_watcher(self):
    t = threading.Thread(target=watch, args=(self,))
    t.daemon = True
    t.start()

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
    try:
      with open(item, "r") as f:
        property_files[item] = Properties(f)
    except IOError, e:
      print e
      return

  def _create_indexer(self, property_files):
    docs = []
    for property_file_key in property_files.keys():
      property_file = property_files[property_file_key]

      for prop_key in property_file.keys():
        docs.append((property_file_key, prop_key))

    return PropertyIndexer(docs)


def main(args):
  port = int(args[1])
  lockFile = args[2]
  ThreadedTCPServer(RequestHandler, port, lockFile).serve_forever()

if __name__ == '__main__':
  main(sys.argv)

