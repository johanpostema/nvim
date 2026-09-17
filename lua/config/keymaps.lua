vim.g.mapleader = " "

-- toggle the netrw directory browser, remembering which buffer to return to
local netrw_prev_buf = nil
vim.keymap.set("n", "<leader>cd", function()
    if vim.bo.filetype == "netrw" then
        if netrw_prev_buf and vim.api.nvim_buf_is_valid(netrw_prev_buf) then
            vim.api.nvim_set_current_buf(netrw_prev_buf)
        else
            vim.cmd("buffer #")
        end
    else
        netrw_prev_buf = vim.api.nvim_get_current_buf()
        vim.cmd.Ex()
    end
end, { desc = "Toggle directory browser" })

-- move selected lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")       -- join lines, keep cursor in place
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- keep cursor centered while paging
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")       -- keep search matches centered
vim.keymap.set("n", "N", "Nzzzv")

-- paste without clobbering the unnamed register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank also goes to the system clipboard; delete/change stay purely internal
vim.keymap.set({ "n", "x" }, "y", [["+y]], { desc = "Yank (also to clipboard)" })
vim.keymap.set("n", "Y", [["+y$]], { desc = "Yank to end of line (also to clipboard)" })

vim.keymap.set("i", "<C-c>", "<Esc>")

-- insert a shell command's (trimmed) output at the cursor.
-- Uses <C-o> (Vim's own native "run one command, then resume insert exactly
-- where I was" mechanism) instead of vim.fn.input(), which was reproducibly
-- dropping the character right before the cursor in real typing sessions.
--
-- While the one-shot command runs, we're technically in Normal mode, which
-- can't place the cursor *past* the last character the way Insert mode can
-- (there's nothing there to point "at"). So at end-of-line,
-- nvim_win_get_cursor() under-reports the column by one. The '^' mark
-- ("position where Insert mode was last stopped") isn't clamped like that,
-- so use it instead to find where to insert.
vim.api.nvim_create_user_command("InsertCmdOutput", function(opts)
  local lines = vim.split(vim.trim(vim.fn.system(opts.args)), "\n")
  local pos = vim.fn.getpos("'^") -- {bufnum, lnum, col, off}, col is 1-indexed
  local row, col = pos[2], pos[3] - 1
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)
end, { nargs = "+" })

-- note: <C-b> and <C-r>{register} both looked like natural picks but are
-- claimed elsewhere (blink.cmp's "enter" preset, and Vim's native
-- paste-from-register prefix respectively); "!" is not a valid register
-- name though, so <C-r>! doesn't actually collide with the latter.
vim.keymap.set("i", "<C-r>!", "<C-o>:InsertCmdOutput ", { desc = "Insert shell command output at cursor" })

-- window navigation (AstroNvim-style)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- buffer navigation (Cmd+[/] don't reach nvim through iTerm2 reliably)
vim.keymap.set("n", "<C-]>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-p>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>rl", "<cmd>source $MYVIMRC<CR>", { desc = "Reload init.lua" })

-- toggle comment (reuses Neovim's built-in gcc/gc, see :h gcc-default)
vim.keymap.set("n", "<leader><leader>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("x", "<leader><leader>", "gc", { remap = true, desc = "Toggle comment" })

-- quickfix list
vim.keymap.set("n", "<leader>cl", "<cmd>cclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz")

-- clear multicursors (native <C-L> default; ours is taken by window-nav)
vim.keymap.set("n", "<leader>mc", function()
  vim.cmd("nohlsearch")
  vim.cmd("diffupdate")
  vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("nvim.multicursor"), 0, -1)
end, { desc = "Clear multicursors" })

vim.keymap.set("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spellcheck: " .. (vim.wo.spell and "on" or "off"))
end, { desc = "Toggle spellcheck" })
