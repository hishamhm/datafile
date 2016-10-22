
local test_child = {}
local datafile = require("datafile")

function test_child.yo()
   local fd = datafile.open("resources/response.txt")
   local reply = fd:read("*a")
   fd:close()
   print("Path:", datafile.path("resources/response.txt"))
   
   print(reply)
end

return test_child
