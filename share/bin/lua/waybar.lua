#!/usr/bin/env lua

local home    = os.getenv("HOME")
package.path  = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils   = require("utils")
local exec    = utils.exec
local capture = utils.execCapture
local proc    = utils.proc

------------------------------------------------------------------------------------------------------------------------

local wayConf = home .. "/.config/waybar"

---@param opts? { side?: string }
local function set(opts)
        opts           = opts or {}
        local side     = opts.side or "bottom"

        local config   = wayConf .. "/" .. side .. ".jsonc"
        local style    = wayConf .. "/" .. side .. ".css"
        local way_proc = proc("waybar")

        if type(tonumber(way_proc)) == "number" then
                exec("pkill" .. " " .. "-x" .. " " .. "waybar")
        else
                exec("waybar" .. " " .. "-c" .. " " .. config .. " " .. "-s" .. " " .. style, true)
        end
end

local bar  = {
        set = function(args)
                set({
                        side = args[1] or "bottom",
                })
        end,
}

local func = arg[1]
if not func then
        os.exit(1)
end

local handler = bar[func]
if not handler then
        os.exit(1)
end

handler({ select(2, table.unpack(arg)) })
