{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../tofi
    ../waybar
    ../dunst.nix
    ../swaybg.nix

    ./input.nix
    ./layout.nix
    ./window-rules.nix
    ./binds.nix
  ];

  programs.niri.settings = {
    debug.render-drm-device = "/dev/dri/renderD128";

    spawn-at-startup = [
      { command = [ "${lib.getExe config.programs.waybar.package}" ]; }
      { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
    ];

    environment.DISPLAY = ":0";
    prefer-no-csd = true;
  };
}
