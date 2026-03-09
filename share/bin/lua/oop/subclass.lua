#!/usr/bin/env lua

------------------------------------------------------------------------------------------------------------------------
-- SUB CLASS

local BaseClass = require"BaseClass"

---@class SubClass:BaseClass
---@field newPublicProperty boolean
---@field private _newPrivateProperty boolean
local SubClass = BaseClass:new{}

local CONSTANT_1 = 0
local CONSTANT_2 = "default"

---@return SubClass
function SubClass:new()
        local newObject = BaseClass.new(self) --[[@as SubClass]]

        -- Initialization
        newObject.newPublicProperty = false
        newObject._newPrivateProperty = false

        return newObject
end

--- Class function purpose
function SubClass.classFunction(arg1)
end

--- Method purpose
function SubClass:newMethod()
end

function SubClass:overriddenMethod()
        -- New implementation
end

return SubClass
