local set = vim.opt

-- line numbers
set.relativenumber = true
set.number = true

-- indentation
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

-- search
set.ignorecase = true
set.smartcase = true
set.incsearch = true

-- appearance
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"
set.cursorline = true

-- no automatic OS clipboard sync: y/d/c/p use Vim's own register.
-- explicit "+y (see keymaps.lua) sends yanks to the system clipboard.

set.backspace = "indent,eol,start"

-- splits
set.splitbelow = true
set.splitright = true

-- dw/diw/ciw treat "-" as part of a word
set.iskeyword:append("-")

-- keep some context above/below the cursor
set.scrolloff = 8

-- undo history on disk instead of swap/backup files
set.swapfile = false
set.backup = false
set.undofile = true
set.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- faster CursorHold, snappier diagnostics/highlight
set.updatetime = 50
