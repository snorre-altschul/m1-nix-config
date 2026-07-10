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

  xdg.configFile."niri/config.kdl".text =
    # kdl
    ''
      include "nix-generated-config.kdl"
      include optional=true "noctalia.kdl"
    '';
  xdg.configFile.niri-config.target = lib.mkForce "niri/nix-generated-config.kdl";

  programs.niri.settings = {
    # debug.render-drm-device = "/dev/dri/renderD128";

    hotkey-overlay.skip-at-startup = true;

    spawn-at-startup = [
      { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
      { command = [ "sh" "noctalia msg volume-up; noctalia msg volume-down" ]; }
    ];

    xwayland-satellite.enable = true;

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
