_: {
  boot.supportedFilesystems = ["ntfs"];

  boot.binfmt.emulatedSystems = [
    "i686-linux"
    "x86_64-linux"
    "i386-linux"
    "i486-linux"
    "i586-linux"
    "i686-linux"
  ];
  # boot.binfmt.registrations = lib.genAttrs config.boot.binfmt.emulatedSystems (_system: {
  #   fixBinary = true;
  #   matchCredentials = true;
  # });
  # services.qemuGuest.enable = true;
  boot.m1n1CustomLogo = ./m1n1-bootloader-splash-128x128.png;

  # Use systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.grub.enable = false;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.timeoutStyle = "hidden";
  boot.loader.grub.configurationLimit = 5;

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
