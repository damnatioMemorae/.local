#!/usr/bin/env lua

local home     = os.getenv("HOME")
package.path   = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils    = require("utils")
local exec     = utils.exec
local capture  = utils.execCapture
local notify   = utils.notify
local grepWord = utils.grepWord

------------------------------------------------------------------------------------------------------------------------

local function get()
        local value = utils.readFile("/sys/class/backlight/nvidia_0/brightness")

        print(value)
        return value
end

---@param opts { v?: number, mode?: integer }
local function set(opts)
        opts       = opts or {}
        local mode = opts.mode or ""
        local v    = opts.v or 5

        exec("brightnessctl" .. " " .. "set" .. " " .. v .. "%" .. mode)
        notify(tostring(get()))
end

-- METRICS TABLE
local control = {
        get = function()
                get()
        end,
        set = function(args)
                set({
                        v    = args[1] or 5,
                        mode = args[2] or "", ---@diagnostic disable-line: assign-type-mismatch
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
