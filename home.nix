{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/niri
    ./modules/spotify.nix
    ./modules/firefox.nix
    ./modules/foot.nix
    # ./modules/kitty.nix
    ./modules/lsd.nix
    ./modules/iamb.nix
    ./modules/prismlauncher.nix
    # ./modules/obsidian.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  nixpkgs.config.allowUnfree = true;

  services.blueman-applet.enable = true;

  home.packages = with pkgs; [
    gimp3
    signal-desktop
    vesktop
  ];

  programs.mpv = {
    enable = true;
    profiles.youtube = {
      "ytdl-format" = "bestvideo[height<=?1080]+bestaudio/best";
      "slang" = "en";
      "sub-auto" = "fuzzy";
      "ytdl-raw-options" = "ignore-config=,sub-lang=en,write-sub=,write-auto-sub=";
    };
  };

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
