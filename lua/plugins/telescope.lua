local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },
  },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>fc", function()
  builtin.grep_string({ search = vim.fn.expand("%:t:r") })
end, { desc = "Find current file" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find word under cursor" })
vim.keymap.set("n", "<leader>fi", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config files" })
vim.keymap.set("n", "<leader>fm", function()
  builtin.man_pages({ sections = { "ALL" } })
end, { desc = "Man pages" })
vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fC", builtin.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>f'", builtin.marks, { desc = "Marks" })
