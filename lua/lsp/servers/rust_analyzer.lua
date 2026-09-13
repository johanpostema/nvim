vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      formatting = { command = { "rustfmt" } },
    },
  },
})
