#!/usr/bin/env lua

local home     = os.getenv("HOME")
package.path   = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils    = require("utils")
local exec     = utils.exec
local capture  = utils.execCapture
local notify   = utils.notify
local grepWord = utils.grepWord

------------------------------------------------------------------------------------------------------------------------

local MIN      = tonumber(grepWord(capture("cpupower" .. " " .. "frequency-info"),
        { word = "hardware limits", count = 3 }))
local MAX      = math.floor(grepWord(capture("cpupower" .. " " .. "frequency-info"),
        { word = "hardware limits", count = 6 }) * 1000)

local function get()
        local info    = capture("cpupower frequency-info")
        local current = math.floor(grepWord(info, { word = "current CPU frequency", count = 4 }) * 1000)
        print(current)
        local msg = "Current" .. " " .. "CPU" .. " " .. "frequency" .. ":" .. " " .. current .. " " .. "MHz"
        print(msg)
        notify(msg)

        return current, msg
end

---@param opts { v?: integer }
local function set(opts)
        opts       = opts or {}
        local v    = tonumber(opts.v) or 2000
        local mode = opts.mode or "cli"

        local function cli()
                exec("sudo" ..
                        " " ..
                        "/usr/bin/cpupower" .. " " .. "frequency-set" .. " " .. "-u" .. " " .. tostring(v) .. "MHz")
                get()
        end

        local function ui()

        end

        if v < MIN or v > MAX then
                error("Invalid input. Enter a number in a given range" ..
                        " " .. "[" .. MIN .. " " .. "-" .. " " .. MAX .. "]")
        else
                cli()
        end
end

---[[
local opts = {
        get = function()
                get()
        end,
        set = function(args)
                set({
                        v    = args[1] or 2000,
                        mode = args[2] or "cli"
                })
        end,
}

local func = arg[1]
if not func then
        os.exit(1)
end

local handler = opts[func]
if not handler then
        os.exit(1)
end

handler({ select(2, table.unpack(arg)) })
--]]
