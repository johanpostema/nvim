require("which-key").setup({})

require("which-key").add({
  { "<leader>b", group = "Buffer" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>l", group = "LSP" },
  { "<leader>m", group = "Multicursor" },
  { "<leader>u", group = "Toggle UI" },
  { "<leader>t", group = "Terminal" },
})
