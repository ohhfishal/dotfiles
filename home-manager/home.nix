{ config, pkgs, pkgs-unstable, user,  ... }@inputs: {
  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.nixvim.homeModules.nixvim
  ];

  programs.zen-browser = {
    enable = true;
  };
  programs.nixvim.imports = [ ./nvim/nvim.nix ];

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
    pkgs.fzf
    pkgs.fastfetch

    pkgs.starship
    pkgs.jujutsu
    # pkgs.lazyjj

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

    (pkgs.writeShellScriptBin "updateos" ''
      nixos-rebuild switch
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
    ".config/nvim/colors" = {
      source = ./themes/vim;
      recursive = true;
    };
    ".config/eza/theme.yaml" = {
      source = ./themes/eza/one_dark.yaml;
    };
    ".gitconfig" = {
      source = ./sources/gitconfig;
    };
  };


  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-a";
    terminal = "screen-256color";
    keyMode =  "vi";
    mouse = true;
    disableConfirmationPrompt = true;
    extraConfig = ''
      # Start of programs.tmux.extraConfig
      bind-key | split-window -h
      bind-key - split-window -v

      set-option -sg escape-time 10
      set -g lock-after-time 0
      set -g renumber-windows on

      set -g status-bg colour247
      set -g window-status-current-style bg=colour239,fg=white
      set -g remain-on-exit off

      bind-key h select-pane -L
      bind-key k select-pane -U
      bind-key j select-pane -D
      bind-key l select-pane -R
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      bindkey -v
    '';
   
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "git"         # also requires `programs.git.enable = true;`
    #   ];
    #   theme = "robbyrussell";
    # };
  };

  # cat replacement
  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    colors = "auto";
    git = true;
    icons = "auto";
    theme = builtins.readFile  themes/eza/one_dark.yaml;
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
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    cat = "bat";
    less = "bat";
    ls = "eza";
    grep =  "rg";
    tree = "eza --tree";
    t = "tree";
    l = "eza -l";
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
    x = "exit";
    c = "clear";
    v = "nvim";
  };

  home.sessionVariables = {
    FOO = "BAR";
    PYTHONPYCACHEPREFIX = "$HOME/.cache/python";
    NOTES = "$HOME/notes";
    NIX_SHELL_PRESERVE_PROMPT = 1;
    MANPAGER = "bat -plman";
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
