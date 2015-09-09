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

local zmq = require "zmq"
local server = zmq.socket(zmq.PULL)

log("Binding server")
server:bind("tcp://*:22223")

local handleServer = function()
  local msg = server:receive()

  if msg then
    log("Received message: ".. msg)
  end
end

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


server:close()
