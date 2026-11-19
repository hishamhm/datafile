--- @module datafile.openers.luarocks
-- datafile module for modules installed with LuaRocks 3.3 or newer
local luarocks = {}

local ok, path = pcall(require, "luarocks.core.path")
local pok, cfg = pcall(require, "luarocks.core.cfg")
local dok, dir = pcall(require, "luarocks.core.dir")
local mok, manif = pcall(require, "luarocks.core.manif")
if not (ok and pok and dok and mok and manif.load_rocks_tree_manifests) then
   return {}
end

if not cfg.lua_extension and not cfg.init() then
   return {}
end

local util = require("datafile.util")

--- @alias rocks_tree
---| string
---| { name: string?, root: string?, lua_dir: string?, lib_dir: string?, rocks_dir: string? }

--- @param file string
--- @param directory string
--- @return string|nil
local function relative_to(file, directory)
   file = dir.normalize(file)
   directory = dir.normalize(directory)
   local prefix = directory .. "/"
   if file:sub(1, #prefix) == prefix then
      return file:sub(#prefix + 1)
   end
end

--- @param manifest { modules: table<string, string[]>? }
--- @param modname string
--- @return string[]
local function providers(manifest, modname)
   local modules = manifest.modules or {}
   local entries = modules[modname]
   while not entries do
      modname = modname:match("(.*)_[^_]+")
      if not modname then
         return {}
      end
      entries = modules[modname]
   end
   return entries
end

--- @param tree rocks_tree
--- @param manifest { modules: table<string, string[]>? }
--- @param file string
--- @return string[]|nil
local function tree_dirs(tree, manifest, file)
   local lua_dir = path.deploy_lua_dir(tree)
   local lib_dir = path.deploy_lib_dir(tree)
   local rocks_dir = path.rocks_dir(tree)
   local dirs = { lua_dir, lib_dir }

   local relative = relative_to(file, lua_dir) or relative_to(file, lib_dir)
   if relative then
      local modname = path.path_to_module(relative)
      for _, provider in ipairs(providers(manifest, modname)) do
         table.insert(dirs, dir.path(rocks_dir, provider))
      end
      return dirs
   end

   relative = relative_to(file, rocks_dir)
   if relative then
      local provider = relative:match("^([^/]+/[^/]+)/")
      if provider then
         table.insert(dirs, dir.path(rocks_dir, provider))
      end
      return dirs
   end
end

--- @return string[]|nil
--- @return string|nil
function luarocks.get_dirs()
   local level, source = util.stacklevel()
   if not level then return nil, source end
   local file = source:match("^@(.*)$")
   if not file then
      return nil, "could not recognize "..source.." as a LuaRocks module"
   end
   file = dir.normalize(file)
   for _, item in ipairs(manif.load_rocks_tree_manifests("all")) do
      local dirs = tree_dirs(item.tree, item.manifest, file)
      if dirs then
         return dirs
      end
   end
   return nil, "could not recognize "..source.." as a LuaRocks module"
end

return luarocks
