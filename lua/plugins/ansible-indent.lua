-- Ansible convention: `- key: value` is usually followed by more keys of the
-- same mapping (`  another_key: ...`), not a new list item. The stock
-- $VIMRUNTIME/indent/yaml.vim can't tell those two cases apart from a
-- "- key: value" line alone, so it safely keeps the same indent. Nudge it
-- toward the "same mapping" reading here, since that's the common case in
-- Ansible tasks. Falls back to the stock yaml indent for everything else.
local function ansible_indent(lnum)
  local prevlnum = vim.fn.prevnonblank(lnum - 1)
  if prevlnum > 0 then
    local prevline = vim.fn.getline(prevlnum)
    if prevline:match("^%s*%-%s+%S+:%s+%S") then
      return vim.fn.indent(prevlnum) + 2
    end
  end
  return vim.fn.GetYAMLIndent(lnum)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml.ansible",
  group = vim.api.nvim_create_augroup("ansible-indent", { clear = true }),
  callback = function()
    _G.__ansible_indent = ansible_indent
    vim.bo.indentexpr = "v:lua.__ansible_indent(v:lnum)"
  end,
})
