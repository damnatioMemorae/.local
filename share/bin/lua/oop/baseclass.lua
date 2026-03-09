#!/usr/bin/env lua

------------------------------------------------------------------------------------------------------------------------
-- BASE CLASS

--- Describe class purpose
---@class BaseClass
---@field publicProperty1 integer
---@field publicProperty2 string
---@field private _privateProperty1 integer
local BaseClass = {}

---@param object table? Required when subclassing `BaseClass`
---@return BaseClass
function BaseClass:new(object)
        local newObject = setmetatable(object or {}, self)
        self.__index    = self


        -- Initialization
        newObject.publicProperty1   = 0
        newObject.publicProperty2   = ""
        newObject._privateProperty1 = 0

        return newObject
end

---@private
function BaseClass:_privateMethod()
end

--- Method purpose
---@param arg1 integer
---@return boolean
function BaseClass:baseMethod(arg1)
        return false
end

function BaseClass:overriddenMethod()
end

return BaseClass
