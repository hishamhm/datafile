
local datafile = require("datafile")

local fd = assert(datafile.open("resources/greeting.txt"))
local reply = fd:read("*a")
fd:close()

print(reply)

