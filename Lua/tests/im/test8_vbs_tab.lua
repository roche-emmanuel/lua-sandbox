-- pplot1.lua
require( "iup" )

-- Prepare the VBS Tab content:
local 
-- local time_text = iup.text{value = "Enter time here"}
local time_btn = iup.button{title = "Set",tip="Apply the new simulation time", tipballon="yes"}
local line = iup.hbox{time_text, iup.fill{}, time_btn}
local frame = iup.frame{line,title="Set environment time"}

local vbs = iup.hbox{frame,margin="2x2",gap=2}
vbs.tabtitle="VBS"

local tabs = iup.tabs{vbs, expand="yes"}

dlg = iup.dialog{tabs; shrink="yes", title="Plot Example",size="QUARTERxQUARTER"}

dlg:show()

while true do
-- for i=0,100000 do
iup.LoopStep()
end

-- iup.MainLoop()
