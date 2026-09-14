-- bash-language-server doesn't format; shfmt does that separately.
-- Install: brew install shfmt
local warned_missing = false

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.sh", "*.bash" },
  callback = function(args)
    if vim.fn.executable("shfmt") == 0 then
      if not warned_missing then
        warned_missing = true
        vim.notify("shfmt not found on PATH; .sh files won't be auto-formatted (brew install shfmt)",
          vim.log.levels.WARN)
      end
      return
    end

    local buf = args.buf
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local input = table.concat(lines, "\n") .. "\n"

    local result = vim.system({ "shfmt", "-i", "2" }, { stdin = input }):wait()
    if result.code == 0 and result.stdout and result.stdout ~= "" then
      local formatted = vim.split(result.stdout, "\n")
      if formatted[#formatted] == "" then
        table.remove(formatted)
      end
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
    end
  end,
})
