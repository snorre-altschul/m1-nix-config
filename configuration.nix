{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/boot
    # ./apple-silicon-support
    (import ./delete-on-boot.nix {
      inherit lib;
      persistExtraDirectories = [
        "/var/lib/netbird"
      ];
      users = {
        "nixos" = {
          directories = [
            "Documents"
            ".gnupg"
            ".ssh"
            ".local"
            ".cache/mesa_shader_cache"
            ".cache/mesa_shader_cache_db"
            ".cache/Psst"
            ".cache/nix"
            ".config/Signal"
            ".config/vesktop"
            ".config/Element"
            ".config/Yubico"
            ".config/sublime-merge"

            ".local/share/fish"
            ".librewolf"
            ".mozilla"
          ];
          files = [];
        };
      };
    })

    ./modules/nvim.nix
    ./modules/bluetooth.nix
    ./modules/git.nix
    ./modules/netbird.nix
    ./modules/agenix.nix
    ./modules/direnv.nix
    ./modules/yubikey.nix
    ./modules/libvirtd.nix
    ./modules/plymouth.nix
    ./modules/nixos-core.nix
    # ./modules/steam.nix
    # (import ./modules/factorio.nix {
    #   inherit pkgs;
    #   inherit (pkgs) stdenv;
    # })
    # ./modules/podman.nix
    # ./modules/distrobox.nix
    ./modules/docker.nix
    ./nix.nix
    ./modules/auto-update.nix
    (import ./modules/ydotool.nix "nixos")
  ];

  # zram can apparently interfere with unified gpu memory on asahi linux
  # zramSwap.enable = true;

  # use zswap instead
  boot.kernelParams = [
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];

  programs.nix-ld.enable = true;

  nixpkgs.overlays = [
    (_final: prev: {
      uboot-asahi = prev.uboot-asahi.overrideAttrs (old: {
        extraConfig =
          old.extraConfig
          + ''
            CONFIG_SILENT_CONSOLE=y
            CONFIG_SILENT_CONSOLE_UPDATE_ON_SET=y
            CONFIG_EXTRA_ENV_SETTINGS="silent=1\0"
            CONFIG_SILENT_CONSOLE_UNTIL_ENV=y   # suppress early messages too
            CONFIG_SILENT_U_BOOT_ONLY=y         # don't pass 'quiet' to kernel automatically
            CONFIG_BOOTDELAY=1                  # give a window to interrupt
            CONFIG_AUTOBOOT_KEYED=y             # require specific key, not just any key
            CONFIG_AUTOBOOT_KEYED_CTRLC=y       # Ctrl-C as the interrupt key
            CONFIG_AUTOBOOT_PROMPT=" "          # hide the countdown message
            CONFIG_DISPLAY_BOARDINFO_LATE=n
            CONFIG_DEBUG_UART=n
            CONFIG_PREBOOT="setenv silent 1"
            CONFIG_BANNER_PRINT=n
            CONFIG_HIDE_LOGO_VERSION=y
            CONFIG_SYS_CONSOLE_INFO_QUIET=y
            CONFIG_SYS_DEVICE_NULLDEV=y
            CONFIG_SILENT_CONSOLE_UPDATE_ON_RELOC=y
            CONFIG_SYS_CONSOLE_INFO_QUIET=y
            CONFIG_SPL_SILENT_CONSOLE=y
            CONFIG_TPL_SILENT_CONSOLE=y
            CONFIG_VIDEO_LOGO=n
          '';
      });
    })
  ];
  # Specify path to peripheral firmware files.
  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware;
    extractPeripheralFirmware = true;
  };
  hardware.sensor.iio.enable = true; # required for asahi 6.19 firmware update
  hardware.graphics.enable = true;

  networking.hostName = "nixos";
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  services.upower = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Copenhagen";
  # services.automatic-timezoned.enable = true;
  services.avahi.enable = true;

  i18n.defaultLocale = "en_EU.UTF-8";

  # Automatically install all stylix font packages
  fonts.packages =
    config.home-manager.users
    |> builtins.attrValues
    |> map (user: user.stylix.fonts.packages)
    |> builtins.concatLists;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$4kqlgDKD8.xIaomeHxoXv0$nA91xjtIbAMIK6CumO4tGY5XKofOKh4UvvkCAceDyqC";
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "nixos" = import ./home.nix;
    };
  };

  stylix = let
    conf = import ./stylix.nix {inherit inputs;};
  in {
    enable = true;
    inherit (conf) base16Scheme;
    inherit (conf) image;
    autoEnable = true;
    targets = {
      console.enable = false;
      kmscon.enable = false;
    };
    polarity = "dark";

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;

    fonts.sizes.terminal = 10;
  };

  # networking.hosts = {
  #   "212.227.209.24" = [
  #     "traefik.spoodythe.one"
  #     "auth.deprived.dev"
  #   ];
  # };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      "nrb" = "run0 --background= nixos-rebuild switch --flake /etc/nixos";
      "nd" = "nix develop -c fish";
    };
    shellAliases.sudo = "run0 --background= ";
  };
  documentation.man.cache.enable = false;

  # specialisation."work".configuration = {
  #   programs.fish.shellAbbrs."nrb" =
  #     lib.mkForce "nixos-rebuild --sudo switch --flake /etc/nixos --specialisation work";
  #   home-manager.users."nixos".xdg.mimeApps = {
  #     enable = true;
  #     defaultApplications = let
  #       defaultApplications = desktop: {
  #         "text/html" = "${desktop}";
  #         "text/xml" = "${desktop}";
  #         "application/vnd.mozilla.xul+xml" = "${desktop}";
  #         "application/xhtml+xml" = "${desktop}";
  #         "application/pdf" = "${desktop}";
  #         "x-scheme-handler/http" = "${desktop}";
  #         "x-scheme-handler/https" = "${desktop}";
  #         "x-scheme-handler/about" = "${desktop}";
  #         "x-scheme-handler/unknown" = "${desktop}";
  #       };
  #     in
  #       lib.mkForce (defaultApplications "Firefox - work profile.desktop");
  #   };
  # };

  # Minimal TUI displaymanager for loggin in and launching hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd /run/current-system/sw/bin/nice -20 ${config.programs.niri.package}/bin/niri-session";
        user = "nixos";
      };

      # First session auto starts niri
      initial_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "nixos";
      };
    };
  };

  # Needs to be here to override system package and not home-manager package
  programs.niri.package = pkgs.niri.overrideAttrs (super: {
    patches = super.patches ++ [./modules/niri/dwt-msg.patch];
  });

  # FUCK NANO
  programs.nano.enable = false;
  environment.sessionVariables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    sublime-merge
  ];
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.ssh.forwardX11 = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
