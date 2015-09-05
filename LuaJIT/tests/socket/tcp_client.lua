print("Hello from test app!")

local socket = require "socket"

local client = socket.tcp();

local res, msg = client:connect("localhost", 22222)
if res~=1 then
  print ("Error:",msg)
  return
end

client:settimeout(0.01) 

client:send("Hello world\n")

client:close()

print("Client stopped.")

print("Done")
