-- Custom blink.cmp source: offers true/false right after known Ansible
-- play/task boolean keywords (become, gather_facts, ...). The
-- ansible-language-server itself only completes keyword *names*, never
-- their values, so this fills that specific gap.
local BOOLEAN_KEYWORDS = {
  become = true,
  gather_facts = true,
  ignore_errors = true,
  ignore_unreachable = true,
  no_log = true,
  check_mode = true,
  any_errors_fatal = true,
  run_once = true,
  force_handlers = true,
}

local M = {}

function M.new()
  return setmetatable({}, { __index = M })
end

function M:enabled()
  return vim.bo.filetype == "yaml.ansible"
end

function M:get_completions(ctx, callback)
  local before_cursor = ctx.line:sub(1, ctx.cursor[2])
  local keyword = before_cursor:match("^%s*([%w_]+):%s*$")

  local items = {}
  if keyword and BOOLEAN_KEYWORDS[keyword] then
    local kind = require("blink.cmp.types").CompletionItemKind.Value
    for _, value in ipairs({ "true", "false" }) do
      table.insert(items, { label = value, kind = kind, insertText = value })
    end
  end

  callback({ items = items, is_incomplete_forward = true, is_incomplete_backward = true })
  return function() end
end

return M
