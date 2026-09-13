vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  -- hover/completion stay with basedpyright, ruff only lints & formats
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})
