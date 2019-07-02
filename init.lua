
local config = require "config"
local mytimer = tmr.create()

--init.lua
wifi.setmode(wifi.STATION)
wifi.sta.config {ssid=config.wifi.ssid, pwd=config.wifi.pwd}
wifi.sta.connect()

mytimer:register(1000, 1, function ()
	if wifi.sta.getip() == nil then
		print(config.device.name .. " is trying to connect to " .. config.wifi.ssid)
	else
		mytimer:stop()
		print(wifi.sta.getip())
		dofile ("app.lua")
	end
end)

mytimer:start()
