{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.niri.settings.binds = with config.lib.niri.actions;
    {
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
        action.spawn = ["${lib.getExe config.programs.foot.package}"];
      };

      "Mod+D" = {
        hotkey-overlay.title = "Run program with Tofi";
        action.spawn = [
          "${config.programs.tofi.package}/bin/tofi-drun"
          "--drun-launch=true"
        ];
      };

      # "Mod+K" = {
      #   hotkey-overlay.title = "Fuzzy find window";
      #   action.spawn = [
      #     (builtins.toString (pkgs.writeShellScript "niri-fuzzy-find.sh"
      #       /* bash */
      #       ''
      #         windows=$(niri msg --json windows)
      #         choiche=$(echo $windows | ${lib.getExe pkgs.jq} '.[] | "\(.id)) \(.app_id): \(.title)"' | tofi)
      #         id=$(${lib.getExe pkgs.jq} -R -c "$choiche | split(\") \").0")
      #       ''
      #     ))
      #   ];
      # };

      "Mod+C" = {
        hotkey-overlay.title = "Close window";
        action = close-window;
      };

      "Mod+V" = {
        hotkey-overlay.title = "Toggle floating on window";
        action = toggle-window-floating;
      };

      "Mod+Q".action = focus-column-left;
      "Mod+E".action = focus-column-right;

      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;

      # Mod+BracketLeft  { consume-or-expel-window-left; }
      # Mod+BracketRight { consume-or-expel-window-right; }

      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;

      "Mod+Shift+S" = {
        hotkey-overlay.title = "Take screenshot";
        action.screenshot = [];
        # action = screenshot {
        #   show-pointer = false;
        # };
      };

      "Mod+W" = {
        hotkey-overlay.title = "Dynamic screen capture window";
        action = set-dynamic-cast-window;
      };
      "Mod+S" = {
        hotkey-overlay.title = "Dynamic screen capture screen";
        action = set-dynamic-cast-monitor null;
      };

      "Mod+Shift+Q" = {
        action.spawn = [
          (pkgs.writeShellScript "kill-window"
            # bash
            "kill -9 $(niri msg --json pick-window | ${lib.getExe pkgs.jq} '.pid')"
            |> toString)
        ];
      };

      "Mod+F12" = {
        action.spawn = [
          (pkgs.writeShellScript "disable-touchpad"
            # bash
            ''
              niri msg inputs --dwt true
              ${pkgs.libnotify}/bin/notify-send "Touchpad disabled while typing"
            ''
            |> toString)
        ];
      };

      "Mod+F11" = {
        action.spawn = [
          (pkgs.writeShellScript "enable-touchpad"
            # bash
            ''
              niri msg inputs --dwt false
              ${pkgs.libnotify}/bin/notify-send "Touchpad enabled always"
            ''
            |> toString)
        ];
      };

      "Mod+L" = {
        action.spawn = [
          "${lib.getExe config.programs.swaylock.package}"
        ];
      };
    }
    // (builtins.listToAttrs (
      builtins.concatLists (
        builtins.genList (
          i:
            with config.lib.niri.actions; [
              (lib.attrsets.nameValuePair "Mod+${toString i}" {
                hotkey-overlay.title = "Switch to workspace ${toString i}";
                action = focus-workspace i;
              })
              (lib.attrsets.nameValuePair "Mod+Shift+${toString i}" {
                hotkey-overlay.title = "Switch to workspace ${toString i}";
                action.move-column-to-workspace = i;
              })
            ]
        )
        10
      )
    ));
}
