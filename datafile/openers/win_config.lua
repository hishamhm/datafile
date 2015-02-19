--- @module datafile.openers.win_config
-- datafile module for Windows configuration files
-- Checks user and system locations (in that order);
--     %APPDATA%
--     Vista/Win7: %PROGRAMDATA%  XP: %ALLUSERSPROFILE%
-- It only handles context "config"

local win_config = {}

local util = require("datafile.util")

-- add a backspace to a path
local bs = function(p)
  if p:sub(-1,-1) ~= "\\" then
    return p.."\\"
  else
    return p
  end
end

function win_config.opener(file, mode, context)
   if context ~= "config" then
      -- silently skip other contexts
      return nil
   end

   local dirs = { bs(os.getenv("APPDATA")), bs(os.getenv("PROGRAMDATA") or os.getenv("ALLUSERSPROFILE")) }   
   return util.try_dirs(dirs, file, mode, true)
end

return win_config
