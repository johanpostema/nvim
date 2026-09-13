require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    selection_modes = { ["@function.outer"] = "V" },
  },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end,
  { desc = "around function" })
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end,
  { desc = "inside function" })
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end,
  { desc = "around class" })
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end,
  { desc = "inside class" })

vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end,
  { desc = "next function start" })
vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end,
  { desc = "previous function start" })
