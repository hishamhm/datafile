
--- @module datafile.openers.caller
-- datafile module based on caller's path.
local caller = {}

local util = require("datafile.util")

function caller.opener(file, mode, context)
   local level, source = util.stacklevel()
   if not level then return nil, source end
   if source:match("^@") then
      source = source:sub(2)
      -- Start with a reasonable guess if it's a well-installed module on Unix...
      local prefix, luaver, modpath = source:match("(.*)/share/lua/([^/]+)/.*")
      local dirs = {}
      if prefix and luaver and modpath then
         table.insert(dirs, prefix .. "/share/lua/" .. luaver)
         table.insert(dirs, prefix .. "/lib/lua/" .. luaver)
      end
      -- ...then try all parent dirs of module.
      dirs = {}
      prefix = source
      while true do
         prefix = prefix:match("(.+)/+[^/]*")
         if not prefix then break end
         table.insert(dirs, prefix)
      end
      return util.try_dirs(dirs, file, mode)
   end
end

return caller

