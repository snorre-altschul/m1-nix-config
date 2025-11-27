{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./modules/niri
    ./modules/spotify.nix
    ./modules/firefox.nix
    ./modules/foot.nix
    ./modules/lsd.nix
    ./modules/prismlauncher.nix
    ./modules/iamb.nix
    # ./modules/cemu.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  nixpkgs.config.allowUnfree = true;

  services.blueman-applet.enable = true;

  home.packages = with pkgs; [
    gimp3
    mpv
    signal-desktop
  ];

  stylix = let
    conf = import ./stylix.nix {inherit inputs;};
  in {
    enable = true;
    inherit (conf) base16Scheme;
    inherit (conf) image;
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
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "25.11";
}
