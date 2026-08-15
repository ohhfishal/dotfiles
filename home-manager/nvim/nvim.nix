{lib, ...}:
let
  options = {
    noremap = true;
    silent = true;
  };
in
{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  colorscheme = "meh";

  extraConfigLuaPre = ''
    -- Enable filetype detection and plugins
    vim.cmd("filetype plugin indent on")
    vim.cmd("syntax on")
  '';

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  plugins.lualine.enable = true;
  plugins.blink-cmp.enable = true;
  # plugins.blink-cmp-git.enable = true;
  plugins.gitgutter.enable = true;
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
    };
  };

  # Top file selector + plugin deps
  plugins.bufferline = {
    enable = true;
  };
  plugins.web-devicons.enable = true;

  autoCmd = [
    {
      # Check for file changes on cursor hold
      command = "checktime";
      pattern = "*";
      event = [ "CursorHold" ];
    }
    {
      # Toggle cursorline in insert mode
      command = "set cul!";
      pattern = "*";
      event = [ "InsertEnter" "InsertLeave"];
    }
  ];

  keymaps = [
    # Navigate wrapped lines as normal lines
    { key = "j"; action = "gj"; mode = [ "n" "x" ]; inherit options; }
    { key = "k"; action = "gk"; mode = [ "n" "x" ]; inherit options; }

    # -- Buffer operations
    { key = "<Tab>"; action = ":bnext<CR>"; mode = "n"; inherit options; }
    { key = "<S-Tab>"; action = ":bprev<CR>"; mode = "n"; inherit options; }
    { key = "<Leader>d"; action = ":bd<CR>"; mode = "n"; inherit options; }
    # -- Quick escape
    { key = "jj"; action = "<Esc>"; mode = "i"; inherit options; }
    { key = "jj"; action = "<C-c>"; mode = "c"; inherit options; }
    # -- Clear search highlighting
    { key = "<CR>"; action = ":nohlsearch<CR><CR>"; mode = "n"; inherit options; }
    # -- Search and replace
    { key = "<leader>s"; action = ":s/"; mode = "n"; inherit options; }
    { key = "<leader>S"; action = ":%s/"; mode = "n"; inherit options; }  
    # -- NEO-TREE 
    {
      key = "<leader>t";
      action = ":Neotree filesystem toggle position=float<CR>";
      mode = [ "n" ];
      # inherit options;
    }
    {
      key = "<leader>g";
      action = ":Neotree git_status toggle position=float<CR>";
      mode = [ "n" ];
      # inherit options;
    }
    {
      key = "<leader>b";
      action = ":Neotree buffers toggle position=float<CR>";
      mode = [ "n" ];
      # inherit options;
    }

  ];

  opts = {
    # -- Basic settings
    backup = false;
    autoread = true;
    wildmenu = true;
    shiftwidth = 2;
    tabstop = 2;
    expandtab = true;
    backspace = [ "indent" "eol" "start" ];
    scrolloff = 10;
    # -- Search settings
    ignorecase = true;
    smartcase = true;
    showmatch = true;
    # -- Imply 'g' on the end of search;
    gdefault = true;
    cursorline = true;
    cursorcolumn = true;
    mouse = "a";
    wildmode = [ "list" "longest" ];
    wildignore = [ "*.png" "*.pdf" "*.pyc" ];
    number = true;
    relativenumber = true;
    showcmd = true;
    colorcolumn = [ "80" "88" ];
    wrap = true;
    linebreak = true;
    list = false;
    foldmethod = "manual";
    clipboard = "unnamedplus";
    timeoutlen = 300;
    inccommand = "split";
    undofile = true;
    confirm = true;
  };
}
