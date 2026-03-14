#!/usr/bin/env lua

local home     = os.getenv("HOME")
package.path   = package.path .. ";" .. home .. "/.local/share/bin/lua/?.lua"

local utils    = require("utils")
local grepWord = utils.grepWord
local capture  = utils.execCapture
local sleep    = utils.sleep

------------------------------------------------------------------------------------------------------------------------

-- CPU
---@param opts? { stat?: string, t?: integer }
local function cpu(opts)
        opts       = opts or {}
        local stat = opts.stat or "perc"
        local t    = opts.t or 1

        local function getJiffies()
                local line = io.open("/proc/stat", "r"):read("l")

                while not grepWord(line, { word = "cpu", count = 1 }) do
                        line = io.open("/proc/stat", "r"):read("l")
                end

                local parts = {}
                line = line:gsub("^%S+%s*", "")
                for part in line:gmatch("%S+") do
                        parts[#parts + 1] = part
                end

                local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = table.unpack(parts)


                local total      = user + nice + system + idle + iowait + irq + softirq + steal
                local idle_total = idle + iowait

                return total, idle_total
        end

        local t0_total, t0_idle = getJiffies()
        sleep(t / 1000)
        local t1_total, t1_idle = getJiffies()

        local delta_total       = t1_total - t0_total
        local delta_idle        = t1_idle - t0_idle
        local usage             = math.floor((1 - delta_idle / delta_total) * 100)

        if stat == "total" then
                print(t0_total)
        elseif stat == "idle" then
                print(t0_idle)
        elseif stat == "perc" then
                print(usage)
        end
end

-- BATTERY
---@param opts? { stat?: string }
local function bat(opts)
        opts          = opts or {}
        local stat    = opts.stat or "capacity"

        local batFile = capture("ls" .. " " .. "/sys/class/power_supply/")
        local batName = grepWord(batFile, { word = "BAT", count = 1 })
        batFile       = "/sys/class/power_supply/" .. batName .. "/"

        local status  = io.open(batFile .. stat, "r"):read("l")
        print(status)
        return status
end

-- MEMORY
---@param opts? { stat?: integer, format?: string, dev?: string }
local function mem(opts)
        opts         = opts or {}
        local dev    = opts.dev or "Mem"
        local stat   = opts.stat or "Total"
        local format = opts.format or "mebi"

        local function getMem(a, b, f)
                local line = io.open("/proc/meminfo", "r"):read("a")
                local mult = 1

                if f == "kilo" then
                        mult = 1000
                elseif f == "kibi" then
                        mult = 1024
                elseif f == "mega" then
                        mult = 1000 * 1000
                elseif f == "mebi" then
                        mult = 1024 * 1024
                elseif f == "giga" then
                        mult = 1000 * 1000 * 1000
                elseif f == "gibi" then
                        mult = 1024 * 1024 * 1024
                elseif f == "tera" then
                        mult = 1000 * 1000 * 1000 * 1000
                elseif f == "tebi" then
                        mult = 1024 * 1024 * 1024 * 1024
                elseif f == "peta" then
                        mult = 1000 * 1000 * 1000 * 1000 * 1000
                elseif f == "pebi" then
                        mult = 1024 * 1024 * 1024 * 1024 * 1024
                end

                ---@diagnostic disable-next-line: param-type-mismatch
                line = grepWord(line, { word = a .. b, count = 2 })
                return math.floor((line * 1000) / mult)
        end

        local total = getMem(dev, "Total", format)

        local used = 0
        if dev == "Swap" then
                local free = getMem(dev, "Free", format)
                used = total - free
        else
                local avail = getMem(dev, "Available", format)
                used = total - avail
        end

        if stat == "Used" then
                print(used)
        elseif stat == "Perc" then
                local perc = math.floor((used / total) * 100)
                print(perc)
        else
                print(getMem(dev, stat, format))
        end
end

---[[ METRICS TABLE
local metrics = {
        cpu = function(args)
                cpu({
                        stat = args[1] or "perc",
                        t    = args[2] or 1
                })
        end,
        bat = function(args)
                bat({
                        stat = args[1] or "capacity"
                })
        end,
        mem = function(args)
                mem({
                        stat   = args[1] or "Perc", ---@diagnostic disable-line: assign-type-mismatch
                        format = args[2] or "mebi",
                        dev    = args[3] or "Mem",
                })
        end,
}

local func    = arg[1]
if not func then
        os.exit(1)
end

local handler = metrics[func]
if not handler then
        os.exit(1)
end

handler({ select(2, table.unpack(arg)) })
--]]
