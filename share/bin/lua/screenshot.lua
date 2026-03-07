#!/usr/bin/env lua

local home          = os.getenv("HOME")
package.path        = package.path .. ";" .. home .. "/" .. ".local/share/bin/lua/?.lua"

local utils         = require("utils")
local exec          = utils.exec
local capture       = utils.execCapture
local confDir       = utils.paths.confDir
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

---@param opts { mode?: string, file?:string }
local function screenshot(opts)
        opts         = opts or {}
        local mode   = opts.mode or "screen"
        local file   = opts.file or saveFile

        local shader = saveShader()

        exec("grimblast" .. " " .. "copysave" .. " " .. mode .. " " .. file)
        exec("swappy" .. " " .. "-f" .. " " .. file, true)

        restoreShader(shader)

        exec("telegram-send" .. " " .. "-f" .. " " .. file, true)
end

---@param opts { send?: boolean, file?: string }
local function extract(opts)
        opts       = opts or {}
        local send = opts.send or false
        local file = opts.file or saveFile
        local text = nil

        exec("grimblast" .. " " .. "copysave" .. " " .. "area" .. " " .. file)
        exec("tesseract" .. " " .. file .. text)
end

local opts = {
        s = function(args)
                screenshot({ mode = "area", file = args[1] or saveFile })
        end,
        m = function(args)
                screenshot({ mode = "output", file = args[1] or saveFile })
        end,
        x = function(args)
                extract({ send = args[1] or false })
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
