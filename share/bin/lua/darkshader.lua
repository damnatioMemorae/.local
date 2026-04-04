#!/usr/bin/env lua

---@diagnostic disable: need-check-nil

local home        = os.getenv("HOME")
package.path      = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils       = require("utils")
local conf_dir    = utils.paths.conf_dir
local far         = utils.findAndReplace

------------------------------------------------------------------------------------------------------------------------

local config_file = conf_dir .. "/hypr/themes/theme.conf"
local str         = "screen_shader = "
local shader_dir  = str .. "~/.config/hypr/shaders/"
local empty       = str .. ""

---@param opts? { shader?: string }
local function toggle(opts)
        opts              = opts or {}
        local shader      = opts.shader or "dark"
        local shader_type = ".frag" or ".glsl"

        far(config_file, shader_dir .. shader .. shader_type, empty)
end

---@param opts? { picker?: string }
local function picker(opts)
        opts        = opts or {}
        local dmenu = opts.menu or "rofi"
end

local shader = {
        toggle = function(args)
                toggle({ shader = args[1] or "dark" })
        end,
        menu   = function(args)
                picker({ menu = args[1] or "rofi" })
        end,
}

local func   = arg[1]
if not func then
        os.exit(1)
end

local handler = shader[func]
if not handler then
        os.exit(1)
end

handler({ select(2, table.unpack(arg)) })
