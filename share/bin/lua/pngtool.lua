#!/usr/bin/env lua

local home    = os.getenv("HOME")
package.path  = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils   = require("utils")
local ls      = utils.ls

------------------------------------------------------------------------------------------------------------------------

local dirs    = ls("/home/q/Downloads/AyuGram Desktop/")

for _, item in ipairs(dirs) do
        print(item)
end
