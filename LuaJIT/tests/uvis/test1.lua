print("Hello from test app!")

local socket = require "socket"

-- create a tcp socket:
local tcp_server, err = socket.tcp();
if tcp_server==nil then 
	return nil, err; 
end

local port = 22222
tcp_server:setoption("reuseaddr", true);
local res, err = tcp_server:bind("*", port);
if res==nil then
	return nil, err;
end

res, err = tcp_server:listen();
if res==nil then 
	return nil, err;
end

local stop_server = 0
local g_client_msg

local client = socket.tcp();
local res, msg = client:connect("localhost", port)
if res~=1 then
  print ("Error:",msg)
  return
end

client:settimeout(0.01) 
client:send("Hello world\n")

while( stop_server==0 ) do
  local err = "";
  local tcp_client = 0;

  -- Set a timeout of 10 ms for accept().
  tcp_client, err = tcp_server:accept();

  -- print("Checking TCP client.")

  if tcp_client~=nil then
	  tcp_client:settimeout(10);

  	print("Got a client, reading message...")

    -- client message must be terminated by 
    -- terminated by a LF character (ASCII 10), 
    -- optionally preceded by a CR character (ASCII 13).
    --
    g_client_msg, err = tcp_client:receive('*l');
    -- g_client_msg, err, partial = tcp_client:receive(13);

    if( g_client_msg~=nil ) then
      if(g_client_msg=="STOP") then
        stop_server = 1;
      else
      	print("Received message: ", g_client_msg)
        tcp_client:send( "Server Echo: " .. g_client_msg .."\n");
      end
    end

    if tcp_client~=nil then
      tcp_client:close();
    end
  end
end

print("Server stopped.")

print("Done")
