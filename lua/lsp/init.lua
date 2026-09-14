vim.lsp.config("*", {
  root_markers = { ".git" },
})

local autoformat_enabled_globally = true

local function autoformat_enabled(buf)
  local buf_override = vim.b[buf].autoformat
  if buf_override ~= nil then
    return buf_override
  end
  return autoformat_enabled_globally
end

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
})

local orig_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 24
  opts.wrap = opts.wrap ~= false
  return orig_open_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf
    local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc }) end

    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "gd", vim.lsp.buf.definition, "Goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
    map("n", "go", vim.lsp.buf.type_definition, "Goto type definition")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
    map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<F2>", vim.lsp.buf.rename, "Rename")
    map({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ async = true }) end, "Format")
    map("n", "<F4>", vim.lsp.buf.code_action, "Code action")

    if client:supports_method("textDocument/documentHighlight") then
      local hl_group = vim.api.nvim_create_augroup("lsp-highlight-" .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- c/cpp formatting via clangd tends to be too opinionated for format-on-save
    local excluded_filetypes = { c = true, cpp = true }
    if client:supports_method("textDocument/formatting")
        and not client:supports_method("textDocument/willSaveWaitUntil")
        and not excluded_filetypes[vim.bo[buf].filetype]
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("lsp-format-" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          if not autoformat_enabled(buf) then
            return
          end
          vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.api.nvim_create_user_command("LspRestart", function()
  local buf = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    client:stop(true)
  end
  vim.defer_fn(function()
    vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
  end, 200)
end, { desc = "Restart LSP clients for the current buffer (picks up settings changes)" })

vim.keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", { desc = "LSP health" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>lD", function()
  require("telescope.builtin").diagnostics()
end, { desc = "All diagnostics" })
vim.keymap.set("n", "<leader>ls", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })

vim.keymap.set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify("Diagnostics: " .. (vim.diagnostic.is_enabled() and "on" or "off"))
end, { desc = "Toggle diagnostics" })

vim.keymap.set("n", "<leader>uf", function()
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].autoformat = not autoformat_enabled(buf)
  vim.notify("Autoformat (buffer): " .. (vim.b[buf].autoformat and "on" or "off"))
end, { desc = "Toggle autoformat (buffer)" })

vim.keymap.set("n", "<leader>uF", function()
  autoformat_enabled_globally = not autoformat_enabled_globally
  vim.notify("Autoformat (global): " .. (autoformat_enabled_globally and "on" or "off"))
end, { desc = "Toggle autoformat (global)" })

local servers = {
  "lua_ls",
  "rust_analyzer",
  "clangd",
  "basedpyright",
  "ruff",
  "jsonls",
  "yamlls",
  "gopls",
  "ansiblels",
  "bashls",
}

for _, name in ipairs(servers) do
  require("lsp.servers." .. name)
end

vim.lsp.enable(servers)
