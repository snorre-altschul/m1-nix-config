{ pkgs, lib, ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = [
    pkgs.asahi-audio
  ];

  hardware.asahi.setupAsahiSound = lib.mkForce false;
}
