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
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.mononoki;
        name = "Mononoki Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  programs.librewolf.enable = true;
  programs.foot.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "25.11";
}
