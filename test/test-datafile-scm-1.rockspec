package="test-datafile"
version="scm-1"

source = {
   url = "git://github.com/hishamhm/datafile",
   dir = "datafile/test",
}

dependencies = {
   "datafile",
}

build = {
   type = "builtin",
   modules = {
      test_module = "test_module.lua",
   },
   install = {
      bin = {
         "test_script",
      }
   },
   copy_directories = {
      "resources",
   }
}
