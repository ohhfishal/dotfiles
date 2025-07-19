{ config, pkgs, ... }:

{
  home.username = "jg";
  home.homeDirectory = "/home/jg";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

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

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  home.file = {
    ".vim" = {
      source = ./sources/vim;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./sources/nvim;
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

  # Set envs
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
