-- Auto-detect ansible yaml files based on common top-level keys/modules.
local function looks_like_ansible(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 60, false)
  for _, line in ipairs(lines) do
    if
        line:match("^%s*hosts:")
        or line:match("^%s*tasks:%s*$")
        or line:match("^%s*roles:%s*$")
        or line:match("^%s*handlers:%s*$")
        or line:match("^%s*gather_facts:")
        or line:match("^%s*become:%s")
        or line:match("ansible%.builtin%.")
        or line:match("ansible%.legacy%.")
    then
      return true
    end
  end
  return false
end

local function maybe_set_ansible(args)
  local buf = args.buf
  local ft = vim.bo[buf].filetype

  if ft == "yaml.ansible" then
    return
  end
  if ft ~= "" and ft ~= "yaml" then
    return
  end

  if looks_like_ansible(buf) then
    vim.bo[buf].filetype = "yaml.ansible"
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("ansible-detect", { clear = true }),
  callback = maybe_set_ansible,
})

-- reuse the yaml treesitter parser for yaml.ansible buffers
vim.treesitter.language.register("yaml", "yaml.ansible")
