{pkgs, inputs, lib, config, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

  ];

  programs.librewolf.enable = true;
  programs.foot.enable = true;
  programs.tofi.enable = true;
  home.activation.regenerateTofiCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
    tofi_cache=${config.xdg.cacheHome}/tofi-drun
    [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
  '';

  programs.git.config = {
    init = {
      defaultBranch = "main";
    };

    user = {
      name = "m1";
      email = "m1@mail.spoodythe.one";
    };
  };

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
        {proportion = 1. / 3.; }
        {proportion = 1. / 2.; }
        {proportion = 2. / 3.; }
      ];

      border = {
        width = 1;
        active = "#ffc87f";
        inactive = "#505050";
        urgent = "#9b0000";
      };
    };

    spawn-at-startup = [
      { command = ["waybar"]; }
    ];

    prefer-no-csd = true;

    window-rules = [
    ];

    binds = {
      "XF86AudioRaiseVolume" = {
        action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volunme" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      };
      "XF86AudioLowerVolume" = {
        action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volunme" "@DEFAULT_AUDIO_SINK@" "0.1-"];
      };

      "Mod+Return" = {
        hotkey-overlay.title = "Open terminal";
        action.spawn = ["${lib.getExe pkgs.foot}"];
      };

      "Mod+D" = {
        hotkey-overlay.title = "Run program with Tofi";
        action.spawn = ["sh" "-c" "${pkgs.tofi}/bin/tofi-drun | sh"];
      };
    };

  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "25.11";
}
