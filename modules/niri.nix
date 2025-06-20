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
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }
      {
        geometry-corner-radius = lib.genAttrs [
          "bottom-left"
          "bottom-right"
          "top-left"
          "top-right"
        ] (_: 4.);
        clip-to-geometry = true;
      }
    ];

    # // Open the Firefox picture-in-picture player as floating by default.
    # window-rule {
    #     // This app-id regular expression will work for both:
    #     // - host Firefox (app-id is "firefox")
    #     // - Flatpak Firefox (app-id is "org.mozilla.firefox")
    #     match app-id=r#"firefox$"# title="^Picture-in-Picture$"
    #     open-floating true
    # }

    binds = with config.lib.niri.actions; {
      "XF86AudioRaiseVolume" = {
        action.spawn = [
          "${pkgs.wireplumber}/bin/wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "5%+"
        ];
      };
      "XF86AudioLowerVolume" = {
        action.spawn = [
          "${pkgs.wireplumber}/bin/wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "5%-"
        ];
      };
      "XF86AudioMute" = {
        action.spawn = [
          "${pkgs.wireplumber}/bin/wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
      };

      "XF86MonBrightnessUp" = {
        action.spawn = [
          "${lib.getExe pkgs.brightnessctl}"
          "s"
          "+5%"
        ];
      };
      "XF86MonBrightnessDown" = {
        action.spawn = [
          "${lib.getExe pkgs.brightnessctl}"
          "s"
          "5%-"
        ];
      };

      "XF86AudioPrev" = {
        action.spawn = [
          (lib.getExe pkgs.playerctl)
          "previous"
        ];
      };
      "XF86AudioPlay" = {
        action.spawn = [
          (lib.getExe pkgs.playerctl)
          "play-pause"
        ];
      };
      "XF86AudioNext" = {
        action.spawn = [
          (lib.getExe pkgs.playerctl)
          "next"
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

      "Mod+V" = {
        hotkey-overlay.title = "Toggle floating on window";
        action = toggle-window-floating;
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
