#!/usr/bin/env lua

local home      = os.getenv("HOME")
package.path    = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils     = require("utils")
local exec      = utils.exec
local capture   = utils.execCapture
local notify    = utils.notify
local grepWord  = utils.grepWord
local grepLines = utils.grepLines

------------------------------------------------------------------------------------------------------------------------

---@param args? { prop?: string }
local function get(args)
        args            = args or {}

        local keyboards = capture("hyprctl" .. " " .. "devices" .. " " .. "-j")

        local paragraph = grepLines(keyboards, '"main": true', '"name"', { direction = "u" })
        print(paragraph)

        local name      = grepWord(paragraph, { word = '"name":', count = 1 })
        print(name)
end

---@param args { layout?: string }
local function set(args)
        args         = args or {}
        local layout = args.layout or "next"
end

local control = {
        get = function(args)
                get({
                        prop = args[1] or "main"
                })
        end,
        set = function(args)
                set({
                        layout = args[1] or "next",
                })
        end,
}

local func    = arg[1]
if not func then
        os.exit(1)
end

local handler = control[func]
if not handler then
        os.exit(1)
end

handler({ select(2, table.unpack(arg)) })
