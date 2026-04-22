#!/usr/bin/env lua

local home     = os.getenv("HOME")
package.path   = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils    = require("utils")
local exec     = utils.exec
local capture  = utils.execCapture
local grepWord = utils.grepWord
local notify   = utils.notify

------------------------------------------------------------------------------------------------------------------------

---@param args? { dev?: string, info?: string }
local function get(args)
        args         = args or {}
        local dev    = args.dev or "Master"
        local info   = args.info or "value"

        local cmd    = "amixer" .. " " .. "sget" .. " "

        local value  = grepWord(capture(cmd .. dev), { pattern = "%[(%d+)%%%]" })
        local status = grepWord(capture(cmd .. dev), { word = "Right:", count = 6 }) or
                   grepWord(capture(cmd .. dev), { word = "Right:", count = 6 })

        if dev == "Master" then
                dev = "Speaker"
        elseif dev == "Capture" then
                dev = "Mic"
        end

        local msg
        if info == "status" then
                msg = dev .. " " .. status
        elseif info == "value" then
                msg = dev .. " " .. value
        elseif info == "both" then
                msg = dev .. " " .. status .. " " .. value
        end

        print(msg)

        return msg
end

---@param args? { dev?: string, v?: integer, mode?: string }
local function set(args)
        args       = args or {}
        local dev  = args.dev or "Master"
        local mode = args.mode or ""
        local v    = args.v or 5

        local cmd  = "amixer" .. " " .. "sset" .. " " .. dev .. " "

        if mode == "+" or mode == "-" then
                exec(cmd .. v .. "%" .. mode)
                notify(get({ dev = dev, info = "value" }), { urgency = "normal" })
        elseif mode == "toggle" then
                exec(cmd .. mode)
                notify(get({ dev = dev, info = "both" }), { urgency = "normal" })
        end
end

local control = {
        get = function(args)
                get({
                        dev  = args[1] or "Master",
                        info = args[2] or "value",
                })
        end,
        set = function(args)
                set({
                        dev  = args[1] or "Master",
                        mode = args[2] or "",
                        v    = args[3] or 5,
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
