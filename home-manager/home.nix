{ config, pkgs, pkgs-unstable, user, pkgs-self, ... }@inputs: {
  imports = [
    # Adds programs.zen-browser
    pkgs-self.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
  };


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

    pkgs.starship
    pkgs.jujutsu
    pkgs.lazyjj

    # General use packages
    pkgs.scrcpy
    pkgs.vlc
    pkgs.amdgpu_top

    # Unfree packages
    pkgs.obsidian

    (pkgs.writeShellScriptBin "updatepkgs" ''
      echo updating flake
      nix flake update --flake ${user.homeDirectory}/config/home-manager
      cat $(which switch)
      switch
    '')

    # Mirror Android devices to record them
    (pkgs.writeShellScriptBin "mirror" ''
      scrcpy -w -t 
    '')

    (pkgs.writeShellScriptBin "switch" ''
      home-manager switch
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

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./sources/vimrc;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
    defaultEditor = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./sources/tmux.conf;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./sources/bashrc + ''

    '';
  };

  # cat replacement
  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
  };

  home.shellAliases = {
    cat = "bat";
    less = "bat";
    grep =  "rg";
    l = "ls -l";
    g = "git";
    j = "jj";
    jd = "j diff";
    jl = "j log";
    jc = "j commit";
    js = "j status";
    jp = "j git push";
    jb = "j b";
    jba = " j b a";
    gs = "git status";
    gd = "git diff";
    gp = "git push";
    gl = "git log";
    config = "pushd $HOME/config";
    notes = "pushd $HOME/notes";
    v = "nvim";
  };

  home.sessionVariables = {
    PYTHONPYCACHEPREFIX = "$HOME/.cache/python";
    NOTES = "$HOME/notes";
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };

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
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
