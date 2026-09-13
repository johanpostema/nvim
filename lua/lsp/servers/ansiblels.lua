vim.lsp.config("ansiblels", {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    ansible = {
      validation = {
        lint = {
          enabled = true,
          -- force the full rule set (name[], fqcn[], ...) instead of
          -- relying on ansible-lint's own project-profile auto-detection
          arguments = "--profile=production",
        },
      },
    },
  },
})
