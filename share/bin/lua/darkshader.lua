#!/usr/bin/env lua

---@diagnostic disable: need-check-nil

local home     = os.getenv("HOME")
package.path   = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils    = require("utils")
local conf_dir = utils.paths.conf_dir
local far      = utils.findAndReplace

------------------------------------------------------------------------------------------------------------------------

local fname    = conf_dir .. "/hypr/themes/theme.conf"
local str      = "screen_shader = "
local dark     = str .. "~/.config/hypr/shaders/dark.frag"
local none     = str .. ""

far(fname, dark, none)
