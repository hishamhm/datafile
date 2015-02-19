
local datafile = {}

-- An array of datafile.openers, analog to package.searchers
datafile.openers = {}

local openers = {
   "datafile.openers.luarocks",
   "datafile.openers.caller",
   "datafile.openers.xdg",
   "datafile.openers.unix",
   "datafile.openers.windows",
}

-- Install openers, if present
for _, opener in ipairs(openers) do
   local ok, mod = pcall(require, opener)
   if ok then
      if mod.opener then
         table.insert(datafile.openers, mod.opener)
      end
   end
end

-- Fallback opener
table.insert(datafile.openers, function(file, mode, _)
   return io.open(file, mode)
end)

function datafile.open(file, mode, context)
   local tried = {}
   for _, opener in ipairs(datafile.openers) do
      local fd, path = opener(file, mode or "r", context)
      if fd then
         return fd, path
      elseif path then
         tried[#tried+1] = path
      end
   end
   return nil, ("file '"..file.."' not found:\n"..table.concat(tried, "\n")):gsub("\n", "\n\t")
end

function datafile.path(file, mode, context)
   local fd, path = datafile.open(file, mode or "r", context)
   if fd then
      fd:close()
      return path
   end
   return nil, path
end

return datafile

