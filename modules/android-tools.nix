{ pkgs, ... }:
{
  # Install android tools
  environment.systemPackages = with pkgs; [
    android-tools
  ];
  # Allow android tools to access usb devices
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
}
