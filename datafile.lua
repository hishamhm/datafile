
local datafile = {}

-- An array of datafile.openers, analog to package.searchers
datafile.openers = {}

local openers = {
   "datafile.openers.luarocks",
   "datafile.openers.caller",
   "datafile.openers.xdg",
   "datafile.openers.unix_config",
}

-- Install openers, if present
for i, opener in ipairs(openers) do
   local ok, mod = pcall(require, opener)
   print(ok, mod)
   if ok then
      if mod.opener then
         table.insert(datafile.openers, mod.opener)
      end
   end
end

-- Fallback opener
table.insert(datafile.openers, function(file, mode, context)
   return io.open(file, mode)
end)

function datafile.open(file, mode, context)
   local tried = {}
   for _, opener in ipairs(datafile.openers) do
      print(opener)
      local file, path = opener(file, mode or "r", context)
      if file then
         return file, path
      elseif path then
         tried[#tried+1] = path
      end
   end
   return nil, ("file '"..file.."' not found:\n"..table.concat(tried, "\n")):gsub("\n", "\n\t")
end

function datafile.path(file, mode, context)
   local file, path = datafile.open(file, mode or "r", context)
   if file then
      file:close()
      return path
   end
   return nil, path
end

return datafile

