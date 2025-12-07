{
  lib,
  inputs,
  ...
}: {
  nix = {
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
    settings = {
      nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      extra-platforms = [
        "i686-linux"
        "x86_64-linux"
        "i386-linux"
        "i486-linux"
        "i586-linux"
        "i686-linux"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = ["14:30"];
    };
    settings.trusted-users = ["@wheel"];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.niri-flake.overlays.niri
  ];
}
