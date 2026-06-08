{
  pkgs,
  lib,
  config,
  ...
}: {
  services.udev.packages = [pkgs.yubikey-personalization];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
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
