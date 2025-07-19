{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  swayidle-time = 600;
in
{
  imports = [
    ../tofi
    ../waybar
    ../dunst.nix
    ../swaybg.nix
    ../swaylock.nix

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
      {
        command = [
          "${lib.getExe config.services.swayidle.package}"
          "timeout"
          "${toString (swayidle-time + 1)}"
          "niri msg action power-off-monitors"
          "timeout"
          "${toString swayidle-time}"
          "${lib.getExe config.programs.swaylock.package} -f"
          "before-sleep"
          "${lib.getExe config.programs.swaylock.package} -f"
        ];
      }
    ];

    environment.DISPLAY = ":0";
    prefer-no-csd = true;
  };
}
