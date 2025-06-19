{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    basix = {
      url = "github:notashelf/basix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.impermanence.nixosModules.impermanence
          inputs.nvf.nixosModules.default

          inputs.niri-flake.nixosModules.niri
          { programs.niri.enable = true; }

          inputs.nixos-apple-silicon.nixosModules.default
          inputs.home-manager.nixosModules.default

          inputs.stylix.nixosModules.stylix

          inputs.nix-index-database.nixosModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
        ];
      };

      formatter."aarch64-linux" = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
    };
}
