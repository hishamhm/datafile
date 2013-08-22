
-- utilities for the implementation of datafile modules
local util = {}

function util.try_dirs(dirs, file, mode, noslash)
   local tried = {}
   for _, dir in ipairs(dirs) do
      local path = (dir..(noslash and "" or "/")..file):gsub("/+", "/")
      local file = io.open(path, mode)
      if file then return file, path end
      tried[#tried+1] = "no file '"..path.."'"
   end
   return nil, table.concat(tried, "\n")
end

return util
