require( "iuplua" )

local lbl = iup.label {title="Current outputs:"}
local text = iup.multiline{expand = "YES", appendnewline="no", formatting="yes"}
local col = iup.vbox { lbl, text, gap=2 }

dlg = iup.dialog{col; title="TCP Server", size="400x200"}
dlg:show()

local log = function(msg)
  text.append = msg .. "\n";
end

log("Creating server")

local socket = require "socket"

-- create a tcp socket:
local tcp_server, err = socket.tcp();
if tcp_server==nil then 
  return nil, err; 
end

log("Binding server")

local port = 22222
tcp_server:setoption("reuseaddr", true);
local res, err = tcp_server:bind("*", port);
if res==nil then
  return nil, err;
end

log("Entering server listen")

res, err = tcp_server:listen();
if res==nil then 
  return nil, err;
end

local stop_server = 0
local g_client_msg

tcp_server:settimeout(0.001)

local handleServer = function()
  local err = "";
  local tcp_client = 0;

  -- Set a timeout of 10 ms for accept().
  tcp_client, err = tcp_server:accept();

  -- log("Checking TCP client.")

  if tcp_client~=nil then
    tcp_client:settimeout(10);

    log("Got a client, reading message...")

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
        log("Received message: ".. g_client_msg)
        tcp_client:send( "Server Echo: " .. g_client_msg .."\n");
      end
    end

    if tcp_client~=nil then
      tcp_client:close();
    end
  end
end

local socket = require "socket"

local res
while (true) do
  res = iup.LoopStep();
  -- log("Handling server...")
  handleServer()
  if res == iup.CLOSE then
    iup.ExitLoop();
    break;
  end
end

