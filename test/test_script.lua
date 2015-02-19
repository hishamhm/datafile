#!/usr/bin/env lua

local test_module = require("test_module")
local test_child = require("test_grandparent.test_parent.test_child")
local datafile = require("datafile")

local fd = assert(datafile.open("resources/greeting.txt"))
local reply = fd:read("*a")
fd:close()

print(reply)

test_module.yo()
test_child.yo()
