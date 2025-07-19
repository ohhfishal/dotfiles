-- Neovim Lua Configuration
-- Converted from vimrc

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

-- Toggle cursorline in insert mode
autocmd({"InsertEnter", "InsertLeave"}, {
  pattern = "*",
  command = "set cul!"
})

-- Color scheme
vim.cmd("colorscheme meh")

-- Key mappings
vim.g.mapleader = " "

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

