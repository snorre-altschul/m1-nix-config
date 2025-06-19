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
    # ./apple-silicon-support
    (import ./delete-on-boot.nix {
      inherit lib;
      users = {
        "nixos" = {
          directories = [
            "Documents"
            ".gnupg"
            ".ssh"
            ".local"
            ".cache/mesa_shader_cache"
            ".cache/mesa_shader_cache_db"

            ".local/share/Steam"
            ".local/share/fish"

          ];
          files = [ ];
        };
      };
    })

    ./modules/nvim.nix
    ./modules/bluetooth.nix
    ./modules/docker.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';

  # Specify path to peripheral firmware files.
  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware;
    useExperimentalGPUDriver = true;
    withRust = true;
  };

  hardware.graphics.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  fonts.packages = [
    pkgs.nerd-fonts.mononoki
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "1234";
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nixos" = import ./home.nix;
    };
  };

  programs.git.config = {
    init = {
      defaultBranch = "main";
    };
    user = {
      name = "m1";
      email = "m1@mail.spoodythe.one";
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
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
      "nd" = "nix develop";
    };
  };
  documentation.man.generateCaches = false;

  # Minimal TUI displaymanager for loggin in and launching hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri";
        user = "nixos";
      };

      # First session auto starts hyprland
      initial_session = {
        command = "/run/current-system/sw/bin/niri";
        user = "nixos";
      };
    };
  };

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
    };
  };

  # FUCK NANO
  programs.nano.enable = false;
  environment.sessionVariables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    # (muvm.overrideAttrs (old: {
    #   buildInputs = old.buildInputs ++ [
    #     (sommelier.overrideAttrs (old: {
    #       doCheck = false;
    #       buildInputs = old.buildInputs ++ [gtest];
    #     }))
    #   ];
    # }))
    muvm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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
