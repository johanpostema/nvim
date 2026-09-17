require("treesitter-context").setup({
  max_lines = 3,
})

vim.keymap.set("n", "<leader>uS", "<cmd>TSContextToggle<CR>", { desc = "Toggle sticky context" })
