#!/usr/bin/env lua

local test_module = require("test_module")
local datafile = require("datafile")

local fd = assert(datafile.open("resources/greeting.txt"))
local reply = fd:read("*a")
fd:close()

print(reply)

test_module.yo()
