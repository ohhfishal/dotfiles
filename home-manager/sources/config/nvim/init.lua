-- Neovim Lua Configuration
-- Converted from vimrc

-- Key mappings
vim.g.mapleader = " "
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
-- vim.g.have_nerd_font = false

-- Basic settings
vim.opt.backup = false  -- Changed from 'set backup' to 'set nobackup' as you had both
vim.opt.autoread = true
vim.opt.path:append("**")
vim.opt.wildmenu = true

-- Swap files directory
vim.opt.directory = vim.fn.expand("$HOME/.vim/swapfiles//")

-- Indentation
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Backspace behavior
vim.opt.backspace = {"indent", "eol", "start"}

vim.opt.scrolloff = 10

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.gdefault = true  -- Imply 'g' on the end of search

-- Cursor highlighting
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Mouse support
vim.opt.mouse = "a"

-- Wildmode settings
vim.opt.wildmode = {"list", "longest"}
vim.opt.wildignore = {"*.dox", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe"}

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.showcmd = true

-- Visual guides
vim.opt.colorcolumn = {"80", "88"}

-- Text wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
-- vim.opt.columns = 90

-- Folding
vim.opt.foldmethod = "manual"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300


-- Sets how neovim will display certain whitespace characters in the editor.
-- TODO: Disabled until I find one I like
vim.o.list = false
-- vim.opt.listchars = { '» ', trail = '·', nbsp = '␣' }


-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Save undo history
vim.o.undofile = true

-- Enable filetype detection and plugins
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Auto commands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Check for file changes on cursor hold
autocmd("CursorHold", {
  pattern = "*",
  command = "checktime"
})

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Toggle cursorline in insert mode
autocmd({"InsertEnter", "InsertLeave"}, {
  pattern = "*",
  command = "set cul!"
})

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Color scheme
vim.cmd("colorscheme meh")

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navigate wrapped lines as normal lines
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("x", "j", "gj", opts)
keymap("x", "k", "gk", opts)

-- Buffer navigation
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprev<CR>", opts)

-- Window navigation (removing 'w' from Ctrl+w combinations)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Tab navigation
keymap("n", "<C-Left>", ":tabprevious<CR>", opts)
keymap("n", "<C-Right>", ":tabnext<CR>", opts)

-- Leader key shortcuts
keymap("n", "<Leader>wq", ":wq<CR>", opts)
keymap("n", "<Leader>w", ":w<CR>", opts)
keymap("n", "<Leader>q", ":q<CR>", opts)
keymap("n", "<Leader>e", ":e ", { noremap = true })
keymap("n", "<Leader>rc", ":e $MYVIMRC<CR>", opts)
keymap("n", "<Leader>r", ":!\"%:p\"<CR>", opts)

-- Buffer operations
keymap("n", "gb", ":ls<CR>:buffer ", { noremap = true })
keymap("n", "gB", ":ls!<CR>:buffer ", { noremap = true })
keymap("n", "<Leader>d", ":bd<CR>", opts)

-- Quick escape
keymap("i", "jj", "<Esc>", opts)
keymap("c", "jj", "<C-c>", opts)

-- Toggle fold
keymap("n", "<Leader><space>", "za", opts)

-- Clear search highlighting
keymap("n", "<CR>", ":nohlsearch<CR><CR>", { noremap = true, silent = true })

-- Search and replace
keymap("n", "<leader>s", ":s/", { noremap = true })
keymap("n", "<leader>S", ":%s/", { noremap = true })

