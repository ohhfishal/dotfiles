{ config, pkgs, pkgs-unstable, user, pkgs-self, ... }: {
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.username = user.username;
  home.homeDirectory = user.homeDirectory;

  # Use the with syntax here
  home.packages = [
    pkgs.cowsay
    pkgs.lolcat

    pkgs-unstable.go
    pkgs-unstable.devenv

    # Dev packages
    pkgs.tmux
    pkgs.rustc
    pkgs.tree
    pkgs.xclip
    pkgs.presenterm
    pkgs.zip
    pkgs.unzip
    pkgs.ripgrep
    pkgs.gnumake
    pkgs.gcc
    pkgs.vlc
    pkgs.jq
    pkgs.python311
    pkgs.tre-command
    pkgs.nh

    pkgs.godot

    # Mirror my phone
    pkgs.scrcpy

    # Testing
    pkgs.ungoogled-chromium
    pkgs.amdgpu_top

    # Unfree packages
    pkgs.obsidian

    # Custom packages
    pkgs-self.dirtree
    pkgs-self.gopher

    (pkgs.writeShellScriptBin "updatepkgs" ''
      echo updating flake
      nix flake update --flake ${user.homeDirectory}/config/home-manager
      echo home-manager switch
      home-manager switch --flake ${user.homeDirectory}/.config/home-manager#${user.username}
    '')

    (pkgs.writeShellScriptBin "switch" ''
      home-manager switch --flake ${user.homeDirectory}/.config/home-manager#${user.username}
    '')
  ];

  # Link config files to the right place
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
    # viAlias = true;
    vimAlias = true;
  };

  # Config tmux
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./sources/tmux.conf;
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
    gp = "git push";
    gl = "git log";
    config = "pushd $HOME/config";
    notes = "pushd $HOME/notes";
    tree = "dirtree";
  };

  # Set envs
  home.sessionVariables = {
    EDITOR = "vim";
    PYTHONPYCACHEPREFIX = "$HOME/.cache/python";
    NOTES = "$HOME/notes";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
