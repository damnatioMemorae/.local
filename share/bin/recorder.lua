#!/usr/bin/env lua

local scrPath       = debug.getinfo(1, "S").source:sub(2)
local scrDir        = scrPath:match("(.*/)")
package.path        = package.path .. ";" .. scrDir .. "?.lua"
local globalcontrol = require("globalcontrol")
require("sh")

local XDG_VIDEOS_DIR = globalcontrol.homeDir .. "Videos"

-- local XDG_VIDEOS_DIR = function()
--         if not os.getenv("XDG_VIDEO_DIR") ~= nil then
--                 XDG_VIDEOS_DIR = globalcontrol.homeDir .. "Videos"
--         end
--                 return XDG_VIDEOS_DIR
-- end

local saveDir  = tostring(XDG_VIDEOS_DIR) .. "/"
local saveFile = saveDir .. "date +'Video-%y-%m-%d_%H-%M-%S.mp4'"

-- globalcontrol.save_shader()

if not arg[1] then
        os.exit(1)
end

local actions = {
        s  = function()
                sh.command("wf-recorder", "-a", "-D", "-r", "120", "-f", saveFile, "-g", arg[1])
        end,
        sa = function()
                sh.command("wf-recorder", "-a", "-D", "-r", "120", "-f", saveFile, "-g", slurp())
        end,
        m  = function()
                sh.command("wf-recorder", "-D", "-r", "120", "-f", saveFile)
        end,
        ma = function()
                sh.command("wf-recorder", "-D", "-r", "120", "-f", saveFile, "-g", slurp())
        end,
}

if pgrep("-x", "wf-recorder", ">/dev/null") then
        pkill("--signal", "SIGTERM", "-x", "wf-recorder")
elseif actions[arg[1]] then
        actions[arg[1]]()
end

globalcontrol.restore_shader()
