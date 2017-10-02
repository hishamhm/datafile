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

local function test_permission_fail()
   -- Unix only
   if not package.config:match("/") then
      return
   end
   
   local function run(...)
      local ok = os.execute(...)
      assert(ok == 0 or ok == true)
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

