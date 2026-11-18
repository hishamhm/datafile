#!/usr/bin/env lua

if not package.config:match("/") then
   print("neovim test skipped: unix only")
   return
end

local function run(command)
   local ok = os.execute(command)
   return ok == true or ok == 0
end

local tmp = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "")
   .. "/datafile-neovim-" .. tostring(os.time())
assert(run("mkdir -p '" .. tmp .. "/plugin/after/schemas'"))

local fd = assert(io.open(tmp .. "/plugin/after/schemas/foo.json", "w"))
fd:write("{}")
fd:close()

_G.vim = {
   api = {
      nvim_get_runtime_file = function(file)
         return { tmp .. "/plugin/" .. file }
      end,
   },
}

local test_dir = arg[0] and arg[0]:match("^(.*)[/\\][^/\\]+$") or "."
package.path = test_dir .. "/../?.lua;" .. package.path

local datafile = require("datafile")
local expected = tmp .. "/plugin/after/schemas/foo.json"
assert(datafile.path("after/schemas/foo.json") == expected, "unexpected path")

_G.vim = nil
assert(require("datafile.openers.neovim").get_dirs(nil, "foo.json") == nil)

run("rm -rf '" .. tmp .. "'")
print("OK neovim")
