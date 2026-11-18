--- @module datafile.openers.neovim
-- datafile module for Neovim runtime files
local neovim = {}

--- @param context string|nil
--- @param file string
--- @return string[]|nil
function neovim.get_dirs(_, file)
   if not (type(vim) == "table" and vim.api and vim.api.nvim_get_runtime_file) then
      return nil
   end
   local ok, paths = pcall(vim.api.nvim_get_runtime_file, file, false)
   if not ok or not paths[1] then
      return nil
   end
   return { (paths[1]:sub(1, #paths[1] - #file):gsub("[/\\]$", "")) }
end

return neovim
