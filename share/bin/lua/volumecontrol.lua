#!/usr/bin/env lua

local home     = os.getenv("HOME")
package.path   = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils    = require("utils")
local exec     = utils.exec
local capture  = utils.execCapture
local grepWord = utils.grepWord
local notify   = utils.notify

------------------------------------------------------------------------------------------------------------------------

---@param opts? { dev?: string, info?: string }
local function get(opts)
        opts        = opts or {}
        local dev   = opts.dev or "Master"

        local value = grepWord(capture("amixer" .. " " .. "sget" .. " " .. dev), { pattern = "%[(%d+)%%%]" })
        print(value)

        return value
end

---@param opts? { dev?: string, v?: integer, mode?: string }
local function set(opts)
        opts       = opts or {}
        local dev  = opts.dev or "Master"
        local v    = opts.v or 5
        local mode = opts.mode or ""

        if mode then
                exec("amixer" .. " " .. "sset" .. " " .. dev .. " " .. v .. "%" .. mode)
        elseif mode == "toggle" then
                exec("amixer" .. " " .. "sset" .. " " .. dev .. " " .. mode)
                notify(get({ dev = dev }), { urgency = "critical" }) ---@diagnostic disable-line: param-type-mismatch
        else
                exec("amixer" .. " " .. "sset" .. " " .. dev .. " " .. v .. "%")
        end

        notify(get({ dev = dev }), { urgency = "normal" }) ---@diagnostic disable-line: param-type-mismatch
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
                        v    = args[2] or 5,
                        mode = args[3] or "",
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
