{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-mesa.url = "github:NixOS/nixpkgs/c5ae371f1a6a7fd27823";
    impermanence.url = "github:nix-community/impermanence";
    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    nixpkgs,
    treefmt-nix,
    systems,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.impermanence.nixosModules.impermanence
        inputs.nvf.nixosModules.default

        inputs.niri-flake.nixosModules.niri
        {programs.niri.enable = true;}

        inputs.nixos-apple-silicon.nixosModules.default
        inputs.home-manager.nixosModules.default

        inputs.stylix.nixosModules.stylix

        inputs.agenix.nixosModules.default
        {environment.systemPackages = [inputs.agenix.packages."aarch64-linux".default];}

        inputs.nix-index-database.nixosModules.nix-index
        {programs.nix-index-database.comma.enable = true;}
      ];
    };
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

    apps = eachSystem (pkgs: rec {
      "nvim" = {
        type = "app";
        program =
          pkgs.lib.getExe
          (inputs.nvf.lib.nvim.neovimConfiguration {
            inherit pkgs;
            modules = [(import ./modules/nvim-configuration.nix {inherit pkgs;})];
          }).neovim;
      };
      default = nvim;
    });
  };
}
