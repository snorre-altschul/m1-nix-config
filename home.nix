{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./modules/niri.nix
    ./modules/tofi
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

  ];

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
    polarity = "dark";
    # image = ./nixos-wallpaper.png;
    autoEnable = true;
    targets.niri.enable = true;
    targets.tofi.enable = true;
  };

  programs.librewolf.enable = true;
  programs.foot.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "25.11";
}
