
-- simple tests for the zmq library:
local zmq = require 'zmq'

print("Initializing...")
zmq.init();

print("Uninitializing...")
zmq.uninit();

print("Creating socket...")
local socket = zmq.socket(0)
socket:close()
socket:open(0)
socket:close()

socket:open(0)

socket = nil

collectgarbage('collect')

print("ZMQ tests finished.");