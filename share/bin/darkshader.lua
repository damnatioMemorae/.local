#!/usr/bin/env lua

local scrPath = debug.getinfo(1, "S").source:sub(2)
local scrDir  = scrPath:match("(.*/)")
package.path  = package.path .. ";" .. scrDir .. "?.lua"

local globalcontrol = require("globalcontrol")

if globalcontrol.pkg_installed("hyprland") then
        local currentShader = tostring(hyprshade("current"))
        -- print(os.execute("hyprshade current"))
        if currentShader == "dark" then
                os.execute("hyprshade" .. " " .. "off")
        else
                os.execute("hyprshade" .. " " .. "on" .. " " .. "dark")
        end
else
        return
end
