
local config = require "config"
local ws = websocket.createClient()
local mytimer = tmr.create()
local mysecondtimer = tmr.create()
local mythirdtimer = tmr.create()

ws:connect(config.server.url)

last_state = 1
pin = 2 --GPIO4

gpio.mode(pin, gpio.INPUT)
gpio.mode(1, gpio.OUTPUT) --GPIO5

mytimer:alarm(100, 1, function()
    if gpio.read(pin) ~= last_state then
		last_state = gpio.read(pin)
        if last_state == 1 then
            ws:send('{"act":"t","dev_id":"'.. config.device.name ..'"}')
        else
            ws:send('{"act":"x","dev_id":"'.. config.device.name ..'"}')
        end
    end
end)

mysecondtimer:alarm(800, 1, function()
    ws:send('{"act":"heartbeats","dev_id":"'.. config.device.name ..'"}')
end)

mythirdtimer:alarm(3600000, 1, function()
    node.restart();
end)
