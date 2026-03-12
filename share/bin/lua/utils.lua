#!/usr/bin/env lua

------------------------------------------------------------------------------------------------------------------------
-- PATHS

_G.home = os.getenv("HOME")

_G.paths = {
        scrDir  = _G.home .. "/" .. ".local/share/bin/lua/",
        confDir = _G.home .. "/" .. ".config/",
}

-- Execute a shell
---@param cmd string
---@param async? boolean
function _G.exec(cmd, async)
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
function _G.execArg(cmd, arg, async)
        if async then
                os.execute(cmd .. arg .. " &" .. ">/dev/null")
        else
                os.execute(cmd)
        end
end

---@param cmd string
---@param a?  string
function _G.execCapture(cmd, a)
        a = a or "a"
        local handle = io.popen(cmd)

        local result = handle:read(a) ---@diagnostic disable-line: need-check-nil
        handle:close() ---@diagnostic disable-line: need-check-nil
        return result
end

-- File I/O
---@param path string
function _G.readFile(path)
        local f = io.open(path, "r")
        if not f then return nil end
        local content = f:read("*a")
        f:close()
        return content:gsub("%s+", "")
end

--[[
---@param opts { path: string, pattern?: string, open?: string, read?: string }
function _G.readFile(opts)
        opts          = opts or {}
        local path    = opts.path or "/"
        local pattern = opts.pattern or "%S+"
        local open    = opts.open or "r"
        local read    = opts.read or "*a"

        local f       = io.open(path, open)
        if not f then return nil end
        local content = f:read(read)
        f:close()
        return content:gsub(pattern, "")
end
--]]

---@param path string
---@param content string
function _G.writeFile(path, content)
        local f = io.open(path, "w")
        if not f then return end
        f:write(content)
        f:close()
end

function _G.saveShader()
        local shader = _G.execCapture("hyprshade current")
        _G.exec("hyprshade off")
        return shader
end

---@param shader? string
function _G.restoreShader(shader)
        if shader then
                _G.exec("hyprshade on" .. " " .. shader)
        end
end

-- NOTIFICATION
---@param msg string
---@param opts? {timeout?: integer, urgency?: "low"|"normal"|"critical"}
function _G.notify(msg, opts)
        msg           = msg or "Notification placeholder"
        opts          = opts or {}
        local urgency = opts.urgency or "normal"
        local timeout = opts.timeout or 2000
        _G.exec("notify-send"
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
function _G.pkgInstalled(cmd)
        -- return _G.exec("command -v" .. " " .. cmd .. " " .. ">/dev/null 2>&1") ~= nil
        return _G.exec("command -v" .. " " .. cmd)
end

-- GREP WORD
---@param text string|function|any
---@param opts { word?: string, pattern?: string, count?: integer }
function _G.grepWord(text, opts)
        opts          = opts or {}
        local word    = opts.word or "*"
        local count   = opts.count or 1
        local pattern = opts.pattern or "[^\n]*" .. word .. "[^\n]*" ---@diagnostic disable-line: ambiguity-1

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
---@param opts { direction?: string }
function _G.grepLines(text, strStart, strStop, opts)
        opts            = opts or {}
        local direction = opts.direction or "d"

        local lines     = {}
        for line in text:gmatch("[^\n]*") do
                table.insert(lines, line)
        end

        local indexStart
        for i, line in ipairs(lines) do
                if line:find(strStart, 1, true) then
                        indexStart = i
                        break
                end
        end

        if not indexStart then
                return
        end

        direction = direction or "d"
        if direction == "d" then
                for i = indexStart, #lines do
                        print(lines[i])
                        if lines[i]:find(strStop, 1, true) then
                                break
                        end
                end
        elseif direction == "u" then
                for i = indexStart, 1, -1 do
                        print(lines[i])
                        if lines[i]:find(strStop, 1, true) then
                                break
                        end
                end
        end
end

-- SLEEP
function _G.sleep(n)
        _G.exec("sleep" .. " " .. n)
end

-- PROC
function _G.proc(name)
        return tostring(_G.execCapture("pgrep" .. " " .. "-x" .. " " .. name))
end
