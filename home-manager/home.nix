{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.username = "jg";
  home.homeDirectory = "/home/jg";

  home.packages = [
    pkgs.cowsay
    pkgs.lolcat

    # Dev packages
    pkgs.tmux
    pkgs.go
    pkgs.rustc
    pkgs.tree

    (pkgs.writeShellScriptBin "switch" ''
      home-manager switch
    '')
  ];

  home.file = {
    ".vim" = {
      source = ./sources/vim;
      recursive = true;
    };
    ".config" = {
      source = ./sources/config;
      recursive = true;
    };
    ".config/nvim/colors" = {
      source = ./sources/vim/colors;
      recursive = true;
    };
    ".tmux.conf" = {
      source = ./sources/tmux.conf;
    };
    ".gitconfig" = {
      source = ./sources/gitconfig;
    };
  };

  # Config vim
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./sources/vimrc;
  };

  # Config neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  # Config Bash
  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./sources/bashrc;
  };

  # Set shell agnostic aliases
  home.shellAliases = {
    l = "ls -l";
    g = "git";
    gs = "git status";
    gd = "git diff";
  };

  # Set envs
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
