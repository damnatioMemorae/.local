#!/usr/bin/env lua

local M = {}
------------------------------------------------------------------------------------------------------------------------

local scrPath = debug.getinfo(1, "S").source:sub(2)
local scrDir  = scrPath:match("(.*/)")
package.path  = package.path .. ";" .. scrDir .. "?.lua"

require("sh")
M.homeDir     = os.getenv("HOME") .. "/"
local homeDir     = os.getenv("HOME") .. "/"
local confDir     = homeDir .. ".config/"
local hydeConfDir = confDir .. "hyde/"
local cacheDir    = homeDir .. ".cache/hyde/"
local thmbDir     = cacheDir .. "thumbs/"
local dcolDir     = cacheDir .. "dcols/"
local scrDir      = homeDir .. ".local/share/bin"
local hashMech    = "sha1sum"


function M.save_shader()
        local shader = hyprshade("current")
        run("hyprshade", "off")
end

function M.restore_shader(shader)
        if shader then
                hyprshade("on", shader)
        end
end

function M.pkg_installed(pkgIn)
        -- if pacman("Qi", pkgIn, "&>/dev/null") then
        if os.execute("pacman" .. " " .. "Qi" .. " " .. pkgIn .. " " .. "&>/dev/null") then
                return true
        elseif pacman("Qi", "flatpak", "&>/dev/null") and flatpak("info", pkgIn, "&>/dev/null") then
                return true
        elseif command("-v", pkgIn, "&>/dev/null") then
                return true
        else
                return false
        end
end

function M.get_aurhlpr()
        if pkg_installed("yay") then
                local aurhlpr = "yay"
                return aurhlpr
        elseif pkg_installed("paru") then
                local aurhlpr = "paru"
                return aurhlpr
        end
end

function M.notify()
        local args = io.input()
        sh.command({ "notify-send", __input = args })
end

------------------------------------------------------------------------------------------------------------------------
return M
