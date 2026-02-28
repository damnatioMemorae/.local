#!/usr/bin/env lua

local home    = os.getenv("HOME")
package.path  = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils   = require("utils")
local capture = utils.execCapture

------------------------------------------------------------------------------------------------------------------------

local shader  = utils.saveShader()
local color   = capture("hyprpicker" .. " " .. "-a" .. " " .. "-l")

if color ~= "" then
        utils.notify(color, { urgerncy = "normal", timeout = 2000 })
end
utils.restoreShader(shader)
