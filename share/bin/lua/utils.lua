#!/usr/bin/env lua

---@diagnostic disable: need-check-nil
---@diagnostic disable: param-type-mismatch

---[[
local M = {}

------------------------------------------------------------------------------------------------------------------------
-- PATHS

M.home = os.getenv("HOME")

M.paths = {
        scrDir   = M.home .. "/" .. ".local/share/bin/lua/",
        conf_dir = M.home .. "/" .. ".config/",
}

-- Execute a shell
---@param cmd string
---@param async? boolean
function M.exec(cmd, async)
        if async then
                os.execute(cmd .. " &" .. ">/dev/null")
        else
                os.execute(cmd)
        end
end

-- Execute a command with arguments
---@param cmd string
---@param async? boolean
---@param arg? table
function M.execArg(cmd, arg, async)
        if async then
                os.execute(cmd .. arg .. " &" .. ">/dev/null")
        else
                os.execute(cmd)
        end
end

---@param cmd string
---@param a?  string
function M.execCapture(cmd, a)
        a = a or "a"
        local handle = io.popen(cmd)

        local result = handle:read(a) ---@diagnostic disable-line: need-check-nil
        handle:close() ---@diagnostic disable-line: need-check-nil
        return result
end

-- File I/O
---@param path string
function M.readFile(path)
        local f = io.open(path, "r")
        if not f then return nil end
        local content = f:read("*a")
        f:close()
        return content:gsub("%s+", "")
end

---@param path string
---@param content string
function M.writeFile(path, content)
        local f = io.open(path, "w")
        if not f then return end
        f:write(content)
        f:close()
end

function M.saveShader()
        local shader = M.execCapture("hyprshade current")
        M.exec("hyprshade off")
        return shader
end

---@param shader? string
function M.restoreShader(shader)
        if shader then
                M.exec("hyprshade on" .. " " .. shader)
        end
end

-- NOTIFICATION
---@param msg string
---@param args? {timeout?: integer, urgency?: "low"|"normal"|"critical"}
function M.notify(msg, args)
        msg           = msg or "Notification placeholder"
        args          = args or {}
        local urgency = args.urgency or "normal"
        local timeout = args.timeout or 2000
        M.exec("notify-send"
                .. " "
                .. "'"
                .. msg
                .. "'"
                .. " "
                .. "-u"
                .. " "
                .. urgency
                .. " "
                .. "-t"
                .. " "
                .. timeout)
end

-- PACKAGE
---@param cmd string
function M.pkgInstalled(cmd)
        -- return M.exec("command -v" .. " " .. cmd .. " " .. ">/dev/null 2>&1") ~= nil
        return M.exec("command -v" .. " " .. cmd)
end

-- GREP WORD
---@param text string|function|any
---@param args { word?: string, pattern?: string, count?: integer }
function M.grepWord(text, args)
        args          = args or {}
        local word    = args.word or "*"
        local count   = args.count or 1
        local pattern = args.pattern or "[^\n]*" .. word .. "[^\n]*" ---@diagnostic disable-line: ambiguity-1

        text          = tostring(text)
        local chunk   = text:match(pattern)
        if not chunk then return nil end
        if not word then return chunk end

        local i = 0
        for res in chunk:gmatch("%S+") do
                i = i + 1
                if i == count then
                        return res
                end
        end
end

-- GREP LINES
---@param text string
---@param strStart string
---@param strStop string
---@param args { direction?: string }
function M.grepLines(text, strStart, strStop, args)
        args            = args or {}
        local direction = args.direction or "d"

        local lines     = {}
        for line in text:gmatch("[^\n]*") do
                table.insert(lines, line)
        end

        local index_start
        for i, line in ipairs(lines) do
                if line:find(strStart, 1, true) then
                        index_start = i
                        break
                end
        end

        if not index_start then
                return
        end

        direction = direction or "d"
        if direction == "d" then
                for i = index_start, #lines do
                        print(lines[i])
                        if lines[i]:find(strStop, 1, true) then
                                break
                        end
                end
        elseif direction == "u" then
                for i = index_start, 1, -1 do
                        print(lines[i])
                        if lines[i]:find(strStop, 1, true) then
                                break
                        end
                end
        end
end

-- FaR
---@param fname string
---@param i string
---@param j? string
function M.findAndReplace(fname, i, j)
        local file    = io.open(fname, "r")
        local content = file:read("*a")
        file:close()

        if content:find(i, 1, true) then
                content = content:gsub(i, j)
        elseif content:find(j, 1, true) then
                content = content:gsub(j, i)
        end

        file = io.open(fname, "w")
        file:write(content)
        file:close()
end

-- LS
---@param dir string
function M.ls(dir)
        local i, t, popen = 0, {}, io.popen
        local pfile = popen("ls -a '" .. dir .. "'")
        for filename in pfile:lines() do
                i    = i + 1
                t[i] = filename
        end
        pfile:close()
        return t
end

-- SLEEP
function M.sleep(n)
        M.exec("sleep" .. " " .. n)
end

-- PROC
function M.proc(name)
        return tostring(M.execCapture("pgrep" .. " " .. "-x" .. " " .. name))
end

------------------------------------------------------------------------------------------------------------------------
return M
--]]
