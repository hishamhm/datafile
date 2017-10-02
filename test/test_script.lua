#!/usr/bin/env lua

local datafile = require("datafile")

local function test_load_by_context()
   local test_module = require("test_module")
   local test_child = require("test_grandparent.test_parent.test_child")
   
   print("Path:", datafile.path("resources/greeting.txt"))
   local fd = assert(datafile.open("resources/greeting.txt"))
   local reply = fd:read("*a")
   fd:close()
   
   print(reply)
   
   test_module.yo()
   test_child.yo()
   print("OK")
   return true
end

assert(test_load_by_context())

local function test_missing()
   print()
   print("The next one will fail with a file-not-found:")
   local fd, err = datafile.open("resources/nonexistant.txt")
   assert(not fd)
   if err then
      print(err)
   end
   print("OK")
   return true
end

assert(test_missing())

local function run(...)
   local ok = os.execute(...)
   assert(ok == 0 or ok == true)
end

local function test_permission_fail()
   -- Unix only
   if not package.config:match("/") then
      return true
   end

   print()
   local dirname = "datafile_no_permission"
   local filename = dirname .. "/datafile_no_permission.txt"
   run("mkdir -p " .. dirname)
   run("touch " .. filename)
   run("ls " .. filename)
   run("chmod -w " .. dirname)
   run("chmod +w " .. filename)
   local fd, err = datafile.open(filename, "w")
   print(err)
   assert(fd)
   fd:close()

   run("chmod -w " .. filename)
   fd, err = datafile.open(filename, "w")
   assert(not fd)
   if err then
      print(err)
   end
   run("chmod +w " .. dirname)
   run("rm -f " .. filename)
   run("rmdir " .. dirname)
   print("OK")
   return true
end

assert(test_permission_fail())

local function test_config()
   -- Unix only
   if not package.config:match("/") then
      return true
   end

   print()
   local confname = os.getenv("HOME").."/.config"
   local dirname = "test_datafile"
   local filename = "/file.txt"
   run("mkdir -p " .. confname .. "/" .. dirname)
   run("touch " .. confname .. "/" .. dirname .. "/" ..filename)
   local fd, err = datafile.open(dirname .. "/" .. filename, "r", "config")
   print(err)
   assert(fd)
   fd:close()
   run("rm -f " .. confname .. "/" .. dirname .. "/" ..filename)
   run("rmdir " .. confname .. "/" .. dirname)
   print("OK")
   return true
end

assert(test_config())
