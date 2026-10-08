require("render-markdown").setup({})

vim.keymap.set("n", "<leader>um", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle markdown rendering" })
