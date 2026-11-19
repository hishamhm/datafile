#!/usr/bin/env lua

if not package.config:match("/") then
   print("custom tree test skipped: unix only")
   return
end

local function run(command)
   local ok = os.execute(command)
   return ok == true or ok == 0
end

local function capture(command)
   local pipe = io.popen(command)
   if not pipe then
      return nil
   end
   local output = pipe:read("*a")
   pipe:close()
   return output
end

local function write(path, content)
   local fd = assert(io.open(path, "w"))
   fd:write(content)
   fd:close()
end

local luarocks = os.getenv("LUAROCKS") or "luarocks"
if not run(luarocks .. " --version >/dev/null 2>&1") then
   print("custom tree test skipped: luarocks not found")
   return
end

local lr_path = capture(luarocks .. " path --lr-path --full 2>/dev/null")
if not lr_path or lr_path:match("^%s*$") then
   lr_path = capture(luarocks .. " path --lr-path 2>/dev/null")
end
if not lr_path or lr_path:match("^%s*$") then
   print("custom tree test skipped: could not determine the LuaRocks module path")
   return
end
lr_path = lr_path:gsub("%s+$", "")
package.path = lr_path .. ";" .. package.path

local test_dir = arg[0] and arg[0]:match("^(.*)[/\\][^/\\]+$") or "."
package.path = test_dir .. "/../?.lua;" .. package.path

local tmp = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "")
   .. "/datafile-custom-tree-" .. tostring(os.time())
assert(run("mkdir -p '" .. tmp .. "/tree/lua' '" .. tmp .. "/tree/lib' '"
   .. tmp .. "/tree/rocks/foo/1.0-1/resources' '" .. tmp .. "/tree/rocks/bar/1.0-1/resources'"))

write(tmp .. "/tree/lua/foo.lua", [[
local datafile = require("datafile")
local path = datafile.path("resources/greeting.txt")
local fd = datafile.open("resources/greeting.txt")
local content
if fd then
   content = fd:read("*a")
   fd:close()
end
return { path = path, content = content }
]])

write(tmp .. "/tree/rocks/manifest", [[
modules = {
   foo = { "foo/1.0-1" },
}
]])

write(tmp .. "/tree/rocks/foo/1.0-1/resources/greeting.txt", "hello from a custom rocks tree\n")

write(tmp .. "/tree/rocks/bar/1.0-1/bar.lua", [[
local datafile = require("datafile")
local path = datafile.path("resources/greeting.txt")
return path
]])

write(tmp .. "/tree/rocks/bar/1.0-1/resources/greeting.txt", "hello from the rocks dir\n")

local cfg = require("luarocks.core.cfg")
assert(cfg.init())
cfg.rocks_trees = {
   {
      name = "custom",
      root = tmp .. "/tree",
      lua_dir = tmp .. "/tree/lua",
      lib_dir = tmp .. "/tree/lib",
      rocks_dir = tmp .. "/tree/rocks",
      bin_dir = tmp .. "/tree/bin",
   },
}

package.path = tmp .. "/tree/lua/?.lua;" .. package.path

local foo = require("foo")
local expected = tmp .. "/tree/rocks/foo/1.0-1/resources/greeting.txt"
assert(foo.path == expected, "unexpected path: " .. tostring(foo.path))
assert(foo.content == "hello from a custom rocks tree\n")

package.path = tmp .. "/tree/rocks/bar/1.0-1/?.lua;" .. package.path

local bar = require("bar")
assert(bar == tmp .. "/tree/rocks/bar/1.0-1/resources/greeting.txt", "unexpected path: " .. tostring(bar))

run("rm -rf '" .. tmp .. "'")
print("OK custom tree")
