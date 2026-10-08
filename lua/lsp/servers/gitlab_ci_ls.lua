vim.lsp.config("gitlab_ci_ls", {
  cmd = { "gitlab-ci-ls" },
  filetypes = { "yaml.gitlab" },
  root_markers = { ".git", ".gitlab-ci.yml" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
