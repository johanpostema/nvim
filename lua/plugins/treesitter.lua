local install_langs = { "lua", "rust", "c", "cpp", "python", "go", "json", "yaml", "markdown", "markdown_inline" }

-- also start treesitter for the compound yaml filetypes detected elsewhere
-- (see plugins.ansible-detect and plugins.gitlab-ci-detect)
local start_filetypes = vim.list_extend(vim.deepcopy(install_langs), { "yaml.ansible", "yaml.gitlab" })

require("nvim-treesitter").setup()
require("nvim-treesitter").install(install_langs)

vim.api.nvim_create_autocmd("FileType", {
  pattern = start_filetypes,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
