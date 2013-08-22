
--- @module datafile.openers.luarocks
-- datafile module for modules installed with LuaRocks
local luarocks = {}

local util = require("datafile.util")
local path = require("luarocks.path")
local manif_core = require("luarocks.manif_core")

function luarocks.opener(file, mode, context)
   local info = debug.getinfo(3, "S")
   print(info.source)
   if info.source:match("^@") then
      
      local prefix, luaver, modpath = info.source:match("(.*)/share/lua/([^/]+)/.*")
      if prefix and luaver and modpath then
         local modname = path.path_to_module(modpath)
         local manifest = manif_core.load_local_manifest(prefix)
         local providers = manifest.modules[modname]
   
         -- try versioned module names
         while not providers do
            local strip = modname:match("(.*)_[^_]+")
            if not strip then break end
            providers = manifest.modules[strip]
         end
         
         local dirs = {
            prefix .. "/share/lua/" .. luaver,
            prefix .. "/lib/lua/" .. luaver,
         }
         
         if providers then
            for _, provider in ipairs(providers) do
               table.insert(dirs, prefix .. "/lib/luarocks/rocks/" .. provider)
               table.insert(dirs, prefix .. "/lib/luarocks/rocks-"..luaver.."/" .. provider)
            end
         end
         
         return util.try_dirs(dirs, file, mode)
      end
   end
   return nil, "could not recognize "..info.source.." as a LuaRocks module"
end

return luarocks

