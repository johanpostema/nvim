vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_markers = { ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    yaml = {
      keyOrdering = false,
      -- add schema mappings here later, e.g. for kubernetes manifests
    },
  },
})
