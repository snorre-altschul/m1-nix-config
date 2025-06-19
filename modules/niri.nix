{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./tofi
    ./waybar
    ./dunst.nix
  ];

  programs.niri.settings = with inputs.niri-flake.lib.kdl; {
    debug.render-drm-device = "/dev/dri/renderD128";

    input = {
      keyboard = {
        repeat-delay = 300;
        repeat-rate = 50;
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true;
      };
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "10%";
      };
    };

    layout = {
      gaps = 8;

      preset-column-widths = [
        { proportion = 1. / 3.; }
        { proportion = 1. / 2.; }
        { proportion = 2. / 3.; }
      ];

      border = {
        width = 1;
      };
    };

    spawn-at-startup = [
      { command = [ "${lib.getExe config.programs.waybar.package}" ]; }
      { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
    ];

    environment.DISPLAY = ":0";

    prefer-no-csd = true;

    window-rules = [
    ];

    binds = with config.lib.niri.actions; {
      "XF86AudioRaiseVolume" = {
        action.spawn = [
          "${pkgs.wireplumber}/bin/wpctl"
          "set-volunme"
          "@DEFAULT_AUDIO_SINK@"
          "0.1+"
        ];
      };
      "XF86AudioLowerVolume" = {
        action.spawn = [
          "${pkgs.wireplumber}/bin/wpctl"
          "set-volunme"
          "@DEFAULT_AUDIO_SINK@"
          "0.1-"
        ];
      };

      "Mod+Return" = {
        hotkey-overlay.title = "Open terminal";
        action.spawn = [ "${lib.getExe pkgs.foot}" ];
      };

      "Mod+D" = {
        hotkey-overlay.title = "Run program with Tofi";
        action.spawn = [
          "sh"
          "-c"
          "${config.programs.tofi.package}/bin/tofi-drun | sh"
        ];
      };

      "Mod+C" = {
        hotkey-overlay.title = "Close window";
        action = close-window;
      };

      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;

      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = expand-column-to-available-width;

      # Mod+BracketLeft  { consume-or-expel-window-left; }
      # Mod+BracketRight { consume-or-expel-window-right; }

      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;
    };

  };
}
