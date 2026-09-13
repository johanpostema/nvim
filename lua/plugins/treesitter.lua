local install_langs = { "lua", "rust", "c", "cpp", "python", "go", "json", "yaml" }

-- also start treesitter for the ansible autodetect filetype (see plugins.ansible-detect)
local start_filetypes = vim.list_extend(vim.deepcopy(install_langs), { "yaml.ansible" })

require("nvim-treesitter").setup()
require("nvim-treesitter").install(install_langs)

vim.api.nvim_create_autocmd("FileType", {
  pattern = start_filetypes,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
