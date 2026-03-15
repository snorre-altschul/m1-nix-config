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
  boot.m1n1CustomLogo = ./m1n1-bootloader-splash.png;

  # Use systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.timeoutStyle = "hidden";
  boot.loader.grub.configurationLimit = 5;

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
