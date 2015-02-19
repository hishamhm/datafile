--- @module datafile.openers.win_data
-- datafile module for Windows data files
-- Checks user and pulic locations (in that order);
--     %USERPROFILE%
--     %PUBLIC%

local win_data = {}

local util = require("datafile.util")

-- add a backspace to a path
local bs = function(p)
  if p:sub(-1,-1) ~= "\\" then
    return p.."\\"
  else
    return p
  end
end


function win_data.opener(file, mode, context)
  
   local dirs = { bs(os.getenv("USERPROFILE")), bs(os.getenv("PUBLIC")) }   
   return util.try_dirs(dirs, file, mode, true)
end

return win_data
