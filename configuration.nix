{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/boot
    # ./apple-silicon-support
    (import ./delete-on-boot.nix {
      inherit lib;
      persistExtraDirectories = [
        "/var/lib/postgresql"
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
            # ".factorio"

            ".local/share/fish"
            ".librewolf"
            ".mozilla"
          ];
          files = [
            ".config/application_default_credentials.json"
          ];
        };
      };
    })

    ./modules/nvim.nix
    ./modules/bluetooth.nix
    ./modules/eba-postgres.nix
    ./modules/git.nix
    # ./modules/factorio.nix
    ./modules/agenix.nix
    (import ./modules/ydotool.nix "nixos")
  ];

  programs.kdeconnect = {
    enable = true;
  };

  nixpkgs.overlays = [
    inputs.niri-flake.overlays.niri
  ];

  programs.nix-ld.enable = true;

  # Specify path to peripheral firmware files.
  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  hardware.graphics.enable = true;

  networking.hostName = "nixos";
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Copenhagen";
  services.automatic-timezoned.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.mononoki
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$4kqlgDKD8.xIaomeHxoXv0$nA91xjtIbAMIK6CumO4tGY5XKofOKh4UvvkCAceDyqC";
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nixos" = import ./home.nix;
    };
  };

  stylix =
    let
      conf = import ./stylix.nix { inherit inputs; };
    in
    {
      enable = true;
      base16Scheme = conf.base16Scheme;
      image = conf.image;
      autoEnable = true;
      polarity = "dark";

      cursor.package = pkgs.bibata-cursors;
      cursor.name = "Bibata-Modern-Ice";
      cursor.size = 24;
    };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      "nrb" = "nixos-rebuild --sudo switch --flake /etc/nixos";
      "nd" = "nix develop -c fish";
    };
  };
  documentation.man.generateCaches = false;

  specialisation."work".configuration = {
    programs.fish.shellAbbrs."nrb" =
      lib.mkForce "nixos-rebuild --sudo switch --flake /etc/nixos --specialisation work";
    home-manager.users."nixos".xdg.mimeApps = {
      enable = true;
      defaultApplications =
        let
          defaultApplications = desktop: {
            "text/html" = "${desktop}";
            "text/xml" = "${desktop}";
            "application/vnd.mozilla.xul+xml" = "${desktop}";
            "application/xhtml+xml" = "${desktop}";
            "application/pdf" = "${desktop}";
            "x-scheme-handler/http" = "${desktop}";
            "x-scheme-handler/https" = "${desktop}";
            "x-scheme-handler/about" = "${desktop}";
            "x-scheme-handler/unknown" = "${desktop}";
          };
        in
        lib.mkForce (defaultApplications ("Firefox - work profile.desktop"));
    };
  };

  # Minimal TUI displaymanager for loggin in and launching hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.programs.niri.package}/bin/niri-session";
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
  programs.niri.package = pkgs.niri-stable.overrideAttrs (super: {
    patches = super.patches ++ [ ./modules/niri/dwt-msg.patch ];
  });

  nix = {
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
    settings = {
      nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-platforms = [
        "i686-linux"
        "x86_64-linux"
        "i386-linux"
        "i486-linux"
        "i586-linux"
        "i686-linux"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://nixos-apple-silicon.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "14:30" ];
    };
    settings.trusted-users = [ "@wheel" ];
  };
  nixpkgs.config.allowUnfree = true;

  # FUCK NANO
  programs.nano.enable = false;
  environment.sessionVariables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    muvm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.sudo = {
    enable = true;
    # I know what im doing
    extraConfig = ''
      Defaults  lecture = never
    '';
  };

  # List services that you want to enable:

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
