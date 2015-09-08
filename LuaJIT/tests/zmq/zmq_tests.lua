
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

-- Should be able to bind and connect a socket:
local client = zmq.socket(zmq.PUSH)
client:connect("tcp://localhost:22221")
local server = zmq.socket(zmq.PULL)
server:bind("tcp://*:22221")

client:send("Hello world!")
local msg = nil

while not msg do
	msg = server:receive()

	if msg then
		print("Received message.")
		assert(msg=="Hello world!")
		break;
	else
		-- print("Waiting...")
	end
end

client:close()
server:close()

print("ZMQ tests finished.");