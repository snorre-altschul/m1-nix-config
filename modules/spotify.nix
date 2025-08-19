{ ... }:
{
  services.spotifyd = {
    enable = true;
    settings = {
      bitrate = 160;
      volume_normalization = true;
      device_name = "m1nix";
    };
  };

  programs.spotify-player = {
    enable = true;
    settings.copy_command = {
      command = "wl-copy";
      args = [ ];
    };
  };
}
