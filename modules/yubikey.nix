{
  pkgs,
  lib,
  config,
  ...
}: {
  services.udev.packages = [pkgs.yubikey-personalization];

  systemd.services."polkit-agent-helper@" = {
    serviceConfig = {
      # 1. Disable device isolation to expose the physical USB buses
      PrivateDevices = false;
      DevicePolicy = "auto";
      DeviceAllow = [""]; # Emits "DeviceAllow=" to clear the upstream whitelist

      # 2. Relax filesystem sandboxing to allow reading/writing challenge states
      ProtectHome = false;
      RestrictAddressFamilies = ["AF_UNIX" "AF_NETLINK"]; # might also need INET and INET6 in some cases
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    systemd-run0.u2fAuth = true;
    polkit-1 = {
      u2fAuth = true;
      rules.auth.u2f.args = lib.mkAfter [
        "pinverification=0"
        "userverification=1"
        "debug"
      ];
    };
    greetd.u2fAuth = true;
    swaylock = {
      u2fAuth = true;
      rules.auth.u2f.args = lib.mkAfter [
        "pinverification=0"
        "userverification=1"
      ];
      rules.auth.unix.order = config.security.pam.services.swaylock.rules.auth.u2f.order - 10;
    };
  };

  boot.initrd.luks.devices."cryptroot".crypttabExtraOpts = [
    "fido2-device=auto" # use fido2 for unlocking if possible
    "token-timeout=10" # wait 10s before prompting for password
  ];
  boot.initrd.luks.fido2Support = false; # systemd handles fido
}
