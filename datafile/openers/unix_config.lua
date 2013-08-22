
--- @module datafile.openers.config
-- datafile module for Unix config files
-- datafile.open("foo/bar.cfg", "r", "config") will try /etc/foo/bar.cfg and $HOME/.foo/bar.cfg
local unix_config = {}

local util = require("datafile.util")

local home = os.getenv("HOME")

function unix_config.opener(file, mode, context)
   if context ~= "config" then
      -- silently skip other contexts
      return nil
   end

   local dirs = { "/etc/", home.."/." }
   return util.try_dirs(dirs, file, mode, true)
end

return unix_config
