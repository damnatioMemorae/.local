#!/usr/bin/env lua

local home          = os.getenv("HOME")
package.path        = package.path .. ";" .. home .. "/" .. ".local/share/bin/lua/?.lua"

local utils         = require("utils")
local exec          = utils.exec
local capture       = utils.execCapture
local confDir       = utils.paths.conf_dir
local saveShader    = utils.saveShader
local restoreShader = utils.restoreShader

------------------------------------------------------------------------------------------------------------------------

local swpyDir       = confDir .. "swappy"
local dateTime      = os.date("%Y-%m-%d_%H-%M-%S")
local saveDir       = home .. "/" .. "Pictures" .. "/" .. "Screenshots"
local saveFile      = saveDir .. "/" .. "Screenshot_" .. dateTime .. ".png"

exec("mkdir" .. " " .. "-p" .. " " .. saveDir)
exec("mkdir" .. " " .. "-p" .. " " .. swpyDir)

local swpyConf = io.open(swpyDir .. "/" .. "/config", "w")
swpyConf:write("[Default]\nsave_dir=" .. saveDir .. "\nsave_filename_format=" .. saveFile) ---@diagnostic disable-line: need-check-nil

---@param args { prg?: string, mode?: string, e?: boolean, file?: string}
local function screenshot(args)
        args         = args or {}
        local prg    = args.prg or "grimblast"
        local mode   = args.mode or "screen"
        local e      = args.e or false
        local file   = args.file or saveFile

        local shader = saveShader()

        if prg == "flameshot" then
                if mode == "screen" then
                        mode = "full"
                        exec(prg .. " " .. mode .. " " .. "-c" .. " " .. "-p" .. " " .. file)
                elseif mode == "area" then
                        mode = "gui"
                        exec(prg .. " " .. mode)
                end
        elseif e then
                exec("grimblast" .. " " .. "copysave" .. " " .. mode .. " " .. file)
                exec("swappy" .. " " .. "-f" .. " " .. file, true)
        else
                exec("grimblast" .. " " .. "copysave" .. " " .. mode .. " " .. file)
        end

        restoreShader(shader)

        exec("telegram-send" .. " " .. "-f" .. " " .. file, true)
end

---@param args { send?: boolean, file?: string }
local function extract(args)
        args       = args or {}
        local send = args.send or false
        local file = args.file or saveFile
        local text = nil

        exec("grimblast" .. " " .. "copysave" .. " " .. "area" .. " " .. file)
        exec("tesseract" .. " " .. file .. text)
end

local args = {
        a = function(args)
                screenshot({
                        prg  = args[1] or "grimblast",
                        mode = args[2] or "area",
                        e    = args[3] or false,
                        file = args[4] or saveFile,
                })
        end,
        s = function(args)
                screenshot({
                        prg  = args[1] or "grimblast",
                        mode = args[2] or "screen",
                        e    = args[3] or false,
                        file = args[4] or saveFile,
                })
        end,
        x = function(args)
                extract({ send = args[1] or false })
        end,
}

local func = arg[1]
if not func then
        os.exit(1)
end

local handler = args[func]
if not handler then
        os.exit(1)
end

handler({ select(2, table.unpack(arg)) })
--]]
