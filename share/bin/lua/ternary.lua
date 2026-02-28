#!/usr/bin/env lua

local x = 0

------------------------------------------------------------------------------------------------------------------------
--[[ BINARY OPERATORS

print("x is" .. " " .. (x < 0 and "negative" or "non-negative"))

print((x < 0 and false or true)) -- does not work
print((x < 0 and true or false)) -- works

--]]

------------------------------------------------------------------------------------------------------------------------
--[[ ANONYMOUS FUNCTIONS

print("x is" .. " " .. (function() if x < 0 then return "negative" else return "non-negative" end end))

--]]

------------------------------------------------------------------------------------------------------------------------
--[[ FUNCTIONAL-IF

local function fif(condition, if_true, if_false)
        if condition then return if_true else return if_false end
end
print(fif(x < 0, "negative", "non-negative"))

--]]

------------------------------------------------------------------------------------------------------------------------
--[[ BOXING/UNBOXING

local condition, a, b = true, false, true
x = (condition and { a } or { b })[1]
print(x)

--]]
