{
  config,
  lib,
  pkgs,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  stylix.targets.waybar.enable = false;

  services.playerctld.enable = true;
  services.playerctld.package = pkgs.playerctl;

  programs.waybar = {
    enable = true;
    # style = ./style.css;

    style = lib.mkForce (
      ''
        @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
        @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

        @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
        @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

        * {
            font-family: "${sansSerif.name}";
            font-size: ${builtins.toString sizes.desktop}pt;
            margin:0;
        }

        window#waybar {
          background: transparent;
        }

        tooltip {
            border-color: @base0D;
            background: alpha(@base00, ${with config.stylix.opacity; builtins.toString desktop});
            color: @base05;
        }
      ''
      + (builtins.readFile ./style.css)
    );

    settings = {
      test = {
        layer = "top";
        output = [ "eDP-1" ];
        position = "top";

        width = 1462;
        height = 33;

        modules-left = [
          "cpu"
          "memory"
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [
          # "image#album-art"
          "mpris"
        ];
        modules-right = [
          "privacy"
          "tray"
          "wireplumber"
          "network"
          "backlight"
          "battery"
          "temperature"
          "clock"
          # "custom/power"
        ];

        fixed-center = true;

        "custom/power" = {
          format = "⏻";
          on-click = "systemctl $(echo \"poweroff\nreboot\nhibernate\" | tofi --prompt-text \"power option: \" --horizontal true --height 35 --width 20%)";
        };

        "network" = {
          format = "Not connected";
          format-wifi = "{essid} ";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-disconnected = "";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "temperature" = {
          critical-threshold = 80;
          thermal-zone = 0;
          format = "  {temperatureC}°C";
        };

        "clock" = {
          format = "{:%H:%M} ";
          format-alt = "{:%A, %B %d, %Y (%R)} ";
          tooltip-format = "{:%Y-%m-%d}";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='@base06'><b>{}</b></span>";
              days = "<span color='@base06'><b>{}</b></span>";
              weeks = "<span color='@base0D'><b>W{}</b></span>";
              weekdays = "<span color='@base0C'><b>{}</b></span>";
              today = "<span color='@base0E'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "backlight" = {
          format = "{percent}% 󰃠";
          tooltip = false;
        };

        "cpu" = {
          interval = 3;
          format = "   {usage}%";
          # format-tooltip = ''
          #   load: {load}
          #   avg: {avg_frequency} GHz
          #   min: {min_frequency} GHz
          #   max: {max_frequency} GHz
          # '';

          # on-click = ''
          #   notify-send "CPU Stats" "avg: {avg_frequency} GHz"
          # '';

          max-length = 10;
        };

        "memory" = {
          format = "   {percentage}% | {swapPercentage}%";
          tooltip = true;
          tooltip-format = "{used}GiB | {swapUsed}GiB";
        };

        "tray" = {
          icon-size = 24;
          spacing = 10;
        };

        "wireplumber" = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          max-volume = 150;
          scroll-step = 0.2;
        };

        "battery" = {
          interval = 60;
          full-at = 96;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";

          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };

        "image#album-art" = {
          exec = pkgs.writeShellScript "album_art.sh" ''
            album_art=$(playerctl metadata | grep artUrl | awk '{ print $3 }')
            if [[ -z $album_art ]]
            then
               # remove image
               echo "/tmp/invalid.tiff";
               # spotify is dead, we should die too.
               exit
            fi
            echo "/tmp/cover.jpeg"
          '';
          size = 32;
          interval = 2;
        };

        "mpris" = {
          format = "{status_icon} {player_icon}  {dynamic}";
          dynamic-length = 50;

          player-icons = {
            # default = "";
            psst = "";
            firefox = "󰈹";
          };

          status-icons = {
            paused = "";
            playing = "";
            stopped = "";
          };

          dynamic-order = [
            "artist"
            "title"
            "position"
            "length"
          ];
          dynamic-seperator = ": ";
          interval = 2;
        };
      };
    };
  };
}
