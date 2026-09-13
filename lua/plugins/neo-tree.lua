require("neo-tree").setup({
  window = {
    mappings = {
      -- prompt for an arbitrary path and jump the tree there
      ["D"] = function()
        local path = vim.fn.input("Neo-tree dir: ", "", "dir")
        if path ~= "" then
          vim.cmd("Neotree dir=" .. vim.fn.fnameescape(vim.fn.expand(path)))
        end
      end,
    },
  },
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
