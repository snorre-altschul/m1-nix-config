{ pkgs, lib, ... }:
{
  hardware.asahi.setupAsahiSound = true;

  services.pipewire.configPackages = lib.mkForce [ ];
  services.pipewire.wireplumber.configPackages = lib.mkForce [ ];

  environment.systemPackages = [ pkgs.asahi-audio ];
}
