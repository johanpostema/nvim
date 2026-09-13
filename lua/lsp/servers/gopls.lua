vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    gopls = {
      staticcheck = true,
    },
  },
})
