-- file.remove("init.lua") node.restart()
print("Ready to start soft ap AND station")
local str = wifi.ap.getmac()
local ssidTemp = string.format("%s%s%s", string.sub(str, 10, 11), string.sub(str, 13, 14), string.sub(str, 16, 17))
wifi.setmode(wifi.STATIONAP)
wifi.setphymode(wifi.PHYMODE_N)

local cfg = {}
cfg.ssid = "ESP8266_" .. ssidTemp
cfg.pwd = "12345678"

print("User: "..cfg.ssid.. " and Password: "..cfg.pwd)
wifi.ap.config(cfg)
cfg = {}
cfg.ip = "192.168.2.1"
cfg.netmask = "255.255.255.0"
cfg.gateway = "192.168.1.1"
wifi.ap.setip(cfg)

wifi.sta.config("TP-LINK_E91ECC", "willianfreire")
wifi.sta.connect()

local cnt = 0
gpio.mode(0, gpio.OUTPUT)
tmr.alarm(
    0,
    1000,
    1,
    function()
        if (wifi.sta.getip() == nil) and (cnt < 20) then
            print("Trying Connect to Router, Waiting...")
            cnt = cnt + 1
            if cnt % 2 == 1 then
                gpio.write(0, gpio.LOW)
            else
                gpio.write(0, gpio.HIGH)
            end
        else
            tmr.stop(0)
            print("Soft AP started")
            print("Heep:(bytes)" .. node.heap())
            print("MAC:" .. wifi.ap.getmac() .. "\r\nIP:" .. wifi.ap.getip())
            if (cnt < 20) then
                print("Conected to Router\r\nMAC:" .. wifi.sta.getmac() .. "\r\nIP:" .. wifi.sta.getip())
            else
                print("Conected to Router Timeout")
            end
            gpio.write(0, gpio.LOW)
            cnt = nil
            cfg = nil
            str = nil
            ssidTemp = nil
            collectgarbage()
        end
    end
)
