--- @module datafile.openers.windows
-- datafile module for Windows locations.
-- Checks data files in user and pulic locations (in that order);
--     %USERPROFILE%
--     %PUBLIC%
-- When given context "config", also checks configuration files in user and system locations (in that order);
--     %APPDATA%
--     Vista/Win7: %PROGRAMDATA%  XP: %ALLUSERSPROFILE%

local windows = {}

local util = require("datafile.util")

function windows.opener(file, mode, _)
   local dirs = {}
   if context == "config" then
      dirs[#dirs+1] = os.getenv("APPDATA")
      dirs[#dirs+1] = (os.getenv("PROGRAMDATA") or os.getenv("ALLUSERSPROFILE")) }
   end
   dirs[#dirs+1] = os.getenv("USERPROFILE")
   dirs[#dirs+1] = os.getenv("PUBLIC")
   return util.try_dirs(dirs, file, mode)
end

return windows
