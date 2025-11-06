{
  description = "Home Manager configuration common users";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # From: https://github.com/0xc000022070/zen-browser-flake
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Tools I wrote
    dirtree.url = "github:ohhfishal/dirtree";
    gopher.url = "github:ohhfishal/gopher";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, dirtree, gopher, zen-browser, ... }:
    let
      system = "x86_64-linux";
      unfree = ["obsidian"];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = (pkg:
          builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
        );
      };
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      # Packages I maintain and use
      pkgs-self = {
        dirtree = dirtree.packages.${system}.default;
        gopher = gopher.packages.${system}.default;
        zen-browser = zen-browser;
      };
    in
    {
      homeConfigurations = {
        jg = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules
          modules = [
            ./home.nix
          ];

          # pass extra arguments
          extraSpecialArgs = {
            user = {
              username = "jg";
              homeDirectory = "/home/jg";
            };
            pkgs-unstable = pkgs-unstable;
            pkgs-self = pkgs-self;
            zen-browser = zen-browser;
          };
        };
      };
    };
}
