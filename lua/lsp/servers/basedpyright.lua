vim.lsp.config("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    basedpyright = {
      analysis = { typeCheckingMode = "standard" },
    },
  },
})
