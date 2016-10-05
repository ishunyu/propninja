#!/usr/bin/python

import sys
import json
import socket

import utils

cmd = sys.argv[2]

requests = {
	"index": {
	  "type":"index",
	  "value": ["/Users/shun.yu/code/my.properties"]
	},
	"search": {
		"type": "search",
		"key": "wd_ho"
	}
}

req_data = json.dumps(requests[cmd])

s = socket.socket()
s.connect(("", int(sys.argv[1])))

utils.send(s, req_data)
resp_data = utils.recv(s)

s.close()

if resp_data:
  resp_obj = json.loads(resp_data)

  print json.dumps(resp_obj)


