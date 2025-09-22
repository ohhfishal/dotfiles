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
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      homeConfigurations = {
        jg = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules
          modules = [ ./home.nix ];

          # pass extra arguments
          extraSpecialArgs = {
            user = {
              username = "jg";
              homeDirectory = "/home/jg";
            };
            pkgs-unstable = pkgs-unstable;
          };
        };
      };
    };
}
