#!/usr/bin/env lua

local path = arg[1]

if not path then
        os.exit(0)
end

path = path:gsub("^file://", "")
path = path:gsub("%%(%x%x)", function (h)
        return string.char(tonumber(h, 16))
end)

os.execute("yazi" .. " " .. path)
