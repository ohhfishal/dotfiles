{ config, pkgs, pkgs-unstable, user, pkgs-self, ... }@inputs: {
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

  imports = [
    # Adds programs.zen-browser
    pkgs-self.zen-browser.homeModules.twilight
  ];

  # Use the with syntax here
  home.packages = [
    # Dev packages
    pkgs-unstable.go
    pkgs-unstable.devenv
    pkgs.tmux
    pkgs.tree
    pkgs.xclip
    pkgs.zip
    pkgs.unzip
    pkgs.ripgrep
    pkgs.gnumake
    pkgs.gcc
    pkgs.jq
    pkgs.python311
    pkgs.nh
    pkgs.fzf

    # General use packages
    pkgs.scrcpy
    pkgs.vlc
    pkgs.amdgpu_top

    # Unfree packages
    pkgs.obsidian

    # inputs.gopher
    inputs.fishy


    (pkgs.writeShellScriptBin "gopher" ''
      $HOME/dev/gopher/gopher "$@"
    '')
    (pkgs.writeShellScriptBin "updatepkgs" ''
      echo updating flake
      nix flake update --flake ${user.homeDirectory}/config/home-manager
      cat $(which switch)
      switch
    '')

    (pkgs.writeShellScriptBin "switch" ''
      home-manager switch
    '')
    (pkgs.writeShellScriptBin "todo" ''
      rg "\/\/ TODO:.*" --trim
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
    defaultEditor = true;
  };

  # Config tmux
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./sources/tmux.conf;
  };

  # Config Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./sources/bashrc + ''

    '';
  };

  programs.zen-browser = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      golang.go
      ms-python.python
      redhat.vscode-yaml
    ];
  };

  # cat replacement
  programs.bat = {
    enable = true;
  };

  # Set shell agnostic aliases
  home.shellAliases = {
    cat = "bat";
    grep =  "rg";
    l = "ls -l";
    g = "git";
    gs = "git status";
    gd = "git diff";
    gp = "git push";
    gl = "git log";
    config = "pushd $HOME/config";
    notes = "pushd $HOME/notes";
  };

  # Set envs
  home.sessionVariables = {
    PYTHONPYCACHEPREFIX = "$HOME/.cache/python";
    NOTES = "$HOME/notes";
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
