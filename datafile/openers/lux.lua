--- @module datafile.openers.lux
-- datafile module for modules installed with Lux.
local util = require("datafile.util")

local ok, lux = pcall(require, "lux")
if not ok or not lux.datafile or type(lux.datafile.dir) ~= "function" then
   return {}
end

local function get_dirs()
   local level, source = util.stacklevel()
   if not level then
      return nil, source
   end
   local dir, err = lux.datafile.dir(source)
   if not dir then
      return nil, err
   end
   return { dir }
end

return { get_dirs = get_dirs }
