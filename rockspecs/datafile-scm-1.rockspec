package = "datafile"
version = "scm-1"

source = {
   url = "git://github.com/hishamhm/datafile.git",
}

description = {
   summary = "A library for handling paths when loading data files",
   detailed = [[
      datafile is a library for avoiding hardcoded paths
      when loading resource files in Lua modules.
   ]],
   homepage = "http://github.com/hishamhm/datafile",
   license = "MIT/X11",
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
      },
      windows = {
         modules = {
            ["datafile.openers.win_config"] = "datafile/openers/win_config.lua",
            ["datafile.openers.win_data"] = "datafile/openers/win_data.lua",
         }
      },
   }
}
