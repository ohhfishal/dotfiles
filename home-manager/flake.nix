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
    gopher.url = "github:ohhfishal/gopher";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@pkgs-self:
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
      # gopher = (builtins.getFlake pkgs-self.gopher.url).packages.${system}.default;
      gopher = pkgs-self.gopher.packages.${system}.default;

      fishySrc = pkgs.fetchFromGitHub {
        owner = "ohhfishal";
        repo = "fishy";
        rev = "v0.2.1";
        sha256 = "sha256-M6UXC0fIRNsLsX0beChrUIgiCqNbjq/BAcxlfrcnhqs=";
      };
      fishy = pkgs.callPackage(fishySrc + "/package.nix") {
        src = fishySrc;
        version = fishySrc.rev;
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
            inherit pkgs-unstable;
            inherit pkgs-self;
            inherit gopher;
            fishy = fishy.fishy;
          };
        };
      };
    };
}
