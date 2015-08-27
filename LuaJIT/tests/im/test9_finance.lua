-- pplot1.lua
require( "iup" )


local cont = iup.vbox{gap=2}
local values = {}

setupSlider = function(options)
	local ival = options.initVal or (options.mini+options.maxi)*0.5
	local fmt = options.format or "%.2f"

	local lbl = iup.label{title=options.caption}
	local pos = iup.val{"HORIZONTAL"; min=options.mini, max=options.maxi, 
		value=ival,expand="horizontal"}
	local txt = iup.label{title=fmt:format(ival), size=30, alignment="aright"}
	local line = iup.hbox{lbl,pos, txt, gap=2}
	iup.Append(options.cont,line)

	function pos:valuechanged_cb()
		-- update the text:
		local val = pos.value+0
		txt.title = fmt:format(val)
		options.handler(val)
	end

	return pos
end

local text = iup.multiline{expand = "YES", appendnewline="no", formatting="yes"}

local maxLot = 3.0

roundLot = function(lot)
	return math.ceil(lot*100)/100
end

updateSerie = function()
	-- local alpha = values.alpha.value+0
	local xp = values.xpoints.value+0
	local yp = values.ypoints.value+0
	local alpha = yp/xp
	local initlot = values.initlot.value+0

	initlot = roundLot(initlot)

	local tt = {}
	table.insert(tt,"Current lotsize:"..initlot..", alpha: "..alpha)

	local lot = initlot
	local count = 1
	local totalLost = 0
	table.insert(tt,"n = ".. 1 .."\tlots=".. lot .. "\twin=" .. math.floor(lot*xp - totalLost)) 
	lot = roundLot(initlot*alpha)
	table.insert(tt,"n = ".. 2 .."\tlots="..lot.. "\twin=" .. math.floor(lot*xp - totalLost))
	while lot < maxLot and count < 100 do
		totalLost = totalLost + math.ceil(lot*yp);
		lot = roundLot(lot*(1+alpha))
		count = count +1
		table.insert(tt,"n = "..count.."\tlots="..lot.. "\twin=" .. math.floor(lot*xp - totalLost))
	end

	text.value = table.concat(tt,"\n")
end

-- values.alpha = setupSlider{caption="Alpha: ",cont=cont,mini=0.0,maxi=1.0,initVal=0.0,format="%.2f",handler=updateSerie}
values.xpoints = setupSlider{caption="X points: ",cont=cont,mini=1.0,maxi=300.0,initVal=100.0,format="%.0f",handler=updateSerie}
values.ypoints = setupSlider{caption="Y points: ",cont=cont,mini=1.0,maxi=300.0,initVal=10.0,format="%.0f",handler=updateSerie}
values.initlot = setupSlider{caption="Init lot: ",cont=cont,mini=0.01,maxi=1.0,initVal=0.01,format="%.2f",handler=updateSerie}

iup.Append(cont,text)

dlg = iup.dialog{cont; shrink="yes", title="Plot Example",size="QUARTERxQUARTER"}

dlg:show()

iup.MainLoop()
