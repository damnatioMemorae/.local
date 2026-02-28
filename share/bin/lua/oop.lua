#!/usr/bin/env lua

local function extended(child, parent)
        setmetatable(child, { __index = parent })
end

------------------------------------------------------------------------------------------------------------------------
---[[ CLASS

Person = {}

function Person:new(fName, lName)
        local obj     = {}
        obj.firstName = fName
        obj.lastName  = lName

        function obj:getName()
                return self.firstName
        end

        setmetatable(obj, self)
        self.__index = self
        return obj
end

local ivan = Person:new("Ivan", "Ivanov")

print(ivan.firstName)

print(ivan:getName())

--]]

------------------------------------------------------------------------------------------------------------------------
--[[ INHERITANCE

Woman = {}

extended(Woman, Person)
local julia = Woman:new("Julia", "Smith")
print(julia:getName())

--]]

------------------------------------------------------------------------------------------------------------------------
--[[ INCAPSULATION

Person = {}

function Person:new(name)
        local private = {}
        private.age   = 18

        local public  = {}
        public.name   = name or "Dima"

        function public:getAge()
                return private.age
        end

        setmetatable(public, self)
        self.__index = self
        return public
end

local dima = Person:new()

print(dima.name)

print(dima.age)

print(dima:getAge())

--]]

------------------------------------------------------------------------------------------------------------------------
--[[ POLYMORPHISM

Person = {}

function Person:new(name)
        local private = {}
        private.age   = 18

        local public = {}
        public.name  = name or "Eblan"

        function public:getName()
                return "Person protected"  .. " ".. self.name
        end

        function Person:getName2()
                return "Person" .. " " .. self.name
        end

        setmetatable(public, self)
        self.__index = self
        return public
end

Woman = {}
extended(Woman, Person)

function Woman:getName()
        return "Woman protected" .. " " .. self.name
end

function Woman:getName2()
        return "Woman" .. " " .. self.name
end

local julia = Woman:new()

print(julia:getName())

print(julia:getName2())

--]]
