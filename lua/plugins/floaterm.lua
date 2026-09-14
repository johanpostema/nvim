-- leave 'terminal mode' with a double <Esc>
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- returns a toggle function for one persistent terminal instance:
-- reuses the same buffer/process across toggles, in the given window layout.
local function make_toggle(opts)
  local state = { buf = -1, win = -1 }

  local function open_win(buf)
    if opts.layout == "float" then
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      return vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
      })
    end

    vim.cmd(opts.layout == "vsplit" and "vsplit" or "split")
    vim.api.nvim_win_set_buf(0, buf)
    return vim.api.nvim_get_current_win()
  end

  return function()
    if vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_hide(state.win)
      return
    end

    local buf = vim.api.nvim_buf_is_valid(state.buf) and state.buf or vim.api.nvim_create_buf(false, true)
    state.buf = buf
    state.win = open_win(buf)

    if vim.bo[buf].buftype ~= "terminal" then
      if opts.cmd then
        vim.cmd.terminal(opts.cmd)
      else
        vim.cmd.terminal()
      end
      vim.bo[buf].buflisted = false -- :terminal marks it listed; undo that
    end
    vim.cmd("startinsert!")
  end
end

local toggle_float = make_toggle({ layout = "float" })
local toggle_vsplit = make_toggle({ layout = "vsplit" })
local toggle_split = make_toggle({ layout = "split" })
local toggle_python = make_toggle({ layout = "float", cmd = "python3" })

vim.api.nvim_create_user_command("Flterm", toggle_float, {})

vim.keymap.set("n", "<leader>tf", toggle_float, { desc = "Floating terminal" })
vim.keymap.set("n", "<leader>tv", toggle_vsplit, { desc = "Vertical split terminal" })
vim.keymap.set("n", "<leader>th", toggle_split, { desc = "Horizontal split terminal" })
vim.keymap.set("n", "<leader>tp", toggle_python, { desc = "Python terminal" })

-- also works while typing inside the terminal itself, unlike <leader>tf which
-- terminal-mode would otherwise just send to the shell as literal keystrokes
vim.keymap.set({ "n", "t" }, "<C-t>", toggle_float, { desc = "Toggle floating terminal" })

-- run the current file in a floating terminal, based on filetype
local function compile_and_run(compiler, file)
  local name = vim.fn.fnamemodify(file, ":t:r"):gsub("[^%w_%-]", "_")
  local bin = "/tmp/" .. name
  return { "sh", "-c", string.format("%s %s -o %s && %s", compiler, vim.fn.shellescape(file), bin, bin) }
end

local function runner_for(filetype, file)
  local runners = {
    python = { "python3", file },
    lua = { "lua", file },
    sh = { "bash", file },
    go = { "go", "run", file },
    ["yaml.ansible"] = { "ansible-playbook", file },
    rust = compile_and_run("rustc", file),
    c = compile_and_run("gcc", file),
    cpp = compile_and_run("g++", file),
  }
  return runners[filetype]
end

local function run_current_file()
  local file = vim.fn.expand("%:p")
  local cmd = runner_for(vim.bo.filetype, file)
  if not cmd then
    vim.notify("No runner configured for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! write")

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. vim.fn.fnamemodify(file, ":t") .. " ",
  })
  vim.fn.jobstart(cmd, { term = true })
  vim.bo[buf].buflisted = false
  vim.cmd("startinsert!")
end

vim.keymap.set("n", "<leader>rr", run_current_file, { desc = "Run current file" })
