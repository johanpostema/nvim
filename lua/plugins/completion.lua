local blink_enabled_globally = true

require("blink.cmp").setup({
  enabled = function() return blink_enabled_globally end,
  keymap = {
    preset = "enter",
    -- Tab accepts the suggestion (like VSCode/JetBrains); falls back to
    -- jumping through a snippet placeholder, then a normal <Tab>.
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then return cmp.accept() end
      end,
      "accept",
      "snippet_forward",
      "fallback",
    },
  },
  completion = {
    documentation = { auto_show = true },
    menu = { max_height = 15 },
    list = {
      selection = {
        -- never auto-select a plain buffer-word match (too easy to
        -- accidentally accept with Tab/<CR> while typing something new
        -- that merely shares a prefix with existing text); LSP/path
        -- matches still preselect as usual.
        preselect = function()
          local top = require("blink.cmp.completion.list").items[1]
          return not (top and top.source_id == "buffer")
        end,
      },
    },
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "buffer", "ansible_bool" },
    providers = {
      ansible_bool = {
        name = "AnsibleBool",
        module = "completion_sources.ansible_bool",
      },
    },
  },
})

vim.keymap.set("n", "<leader>uc", function()
  if vim.b.completion == false then
    vim.b.completion = nil
  else
    vim.b.completion = false
  end
  vim.notify("Completion (buffer): " .. (vim.b.completion == false and "off" or "on"))
end, { desc = "Toggle completion (buffer)" })

vim.keymap.set("n", "<leader>uC", function()
  blink_enabled_globally = not blink_enabled_globally
  vim.notify("Completion (global): " .. (blink_enabled_globally and "on" or "off"))
end, { desc = "Toggle completion (global)" })
