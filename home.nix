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
    ./modules/dunst.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

  ];

  stylix = {
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
    base16Scheme = inputs.basix.schemeData.base16.hopscotch;
    polarity = "dark";
    autoEnable = true;
  };

  programs.librewolf.enable = true;
  programs.foot.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "25.11";
}
