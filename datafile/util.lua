
-- utilities for the implementation of datafile modules
local util = {}

function util.try_dirs(dirs, file, mode, noslash)
   local tried = {}
   for _, dir in ipairs(dirs) do
      local path = (dir..(noslash and "" or "/")..file):gsub("/+", "/")
      local fd = io.open(path, mode)
      if fd then return fd, path end
      tried[#tried+1] = "no file '"..path.."'"
   end
   return nil, table.concat(tried, "\n")
end

-- returns the stack level (for the caller) + sourcefile from where
-- 'datafile' module was called or nil + error
function util.stacklevel()
   local level, info = 1, ""
   while info do
      info = debug.getinfo(level, "S")
      level = level + 1  -- inc before check because me need the match + 1
      if info and info.source:match("datafile.lua$") then
         info = debug.getinfo(level, "S")
         break
      end
   end
   if not info then
      return nil, "could not determine the code file on the callstack to look up"
   else
      return level - 1, info.source  -- use -1 to substract the call to this function
   end
end

return util
