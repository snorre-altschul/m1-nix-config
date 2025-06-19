{ ... }:
{
  boot.plymouth.enable = true;
  boot.loader.grub.timeoutStyle = "hidden";
  boot.kernelParams = [
    "loglevel=3"
    "udev.log_priority=3"
    "quiet"
    "splash"
  ];
}
