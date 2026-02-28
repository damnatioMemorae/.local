#!/usr/bin/env lua

local home   = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

System       = {}

function System:new(modulee)
        local obj  = {}
        obj.module = module

        function obj:get()
                return self.module
        end

        function obj.set()
                return self.module
        end

        setmetatable(obj, self)
        self.__index = self
        return obj
end
