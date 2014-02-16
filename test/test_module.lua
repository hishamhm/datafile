
local test_module = {}
local datafile = require("datafile")

function test_module.yo()
   local fd = datafile.open("resources/response.txt")
   local reply = fd:read("*a")
   fd:close()
   
   print(reply)
end

return test_module
