require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    always_show_bufferline = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
  },
})

vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
