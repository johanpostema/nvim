vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", ".clangd", "Makefile", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
