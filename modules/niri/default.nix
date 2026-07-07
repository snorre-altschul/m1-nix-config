{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ../tofi
    # ../waybar/old
    # ../dunst.nix
    # ../swaybg.nix
    # ../swaylock.nix
    ../noctalia-shell

    ./input.nix
    ./layout.nix
    ./window-rules.nix
    ./binds.nix
  ];

  programs.niri.settings = {
    debug.render-drm-device = "/dev/dri/renderD128";

    spawn-at-startup = [
      {command = ["${lib.getExe pkgs.xwayland-satellite}"];}
      {command = ["sh" "${lib.getExe pkgs.ydotool} mousemove -- 9999 9999"];}
    ];

    switch-events.lid-close.action.spawn = [
      "noctalia"
      "msg"
      "session"
      "lock"
    ];

    clipboard.disable-primary = true;
    input.workspace-auto-back-and-forth = true;

    environment.DISPLAY = ":0";
    prefer-no-csd = true;
    screenshot-path = null;
  };
}
