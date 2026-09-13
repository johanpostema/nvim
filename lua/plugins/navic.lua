local navic = require("nvim-navic")

navic.setup({
  highlight = true,
  separator = " › ",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("navic", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/documentSymbol") then
      navic.attach(client, args.buf)
      vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
  end,
})
