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
    # Tools I wrote
    dirtree.url = "github:ohhfishal/dirtree";
    gopher.url = "github:ohhfishal/gopher";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, dirtree, gopher, ... }:
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
          };
        };
      };
    };
}
