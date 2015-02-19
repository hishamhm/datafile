package = "datafile"
version = "0.1-1"

source = {
   url = "git://github.com/hishamhm/datafile.git",
   tag = "v0.1",
}

description = {
   summary = "A library for handling paths when loading data files",
   detailed = [[
      datafile is a library for avoiding hardcoded paths
      when loading resource files in Lua modules.
   ]],
   homepage = "http://github.com/hishamhm/datafile",
   license = "MIT",
}

dependencies = {
   "lua >= 5.1",
}

build = {
   type = "builtin",
   modules = {
      ["datafile"] = "datafile.lua",
      ["datafile.util"] = "datafile/util.lua",
      ["datafile.openers.luarocks"] = "datafile/openers/luarocks.lua",
      ["datafile.openers.caller"] = "datafile/openers/caller.lua",
      ["datafile.openers.xdg"] = "datafile/openers/xdg.lua",
   },
   platforms = {
      unix = {
         modules = {
            ["datafile.openers.unix_config"] = "datafile/openers/unix_config.lua",
         }
      }
   }
}
