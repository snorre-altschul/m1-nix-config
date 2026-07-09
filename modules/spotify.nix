_: {
  services.spotifyd = {
    enable = false;
    settings = {
      bitrate = 160;
      volume_normalization = true;
      device_name = "m1nix";
    };
  };

  programs.spotify-player = {
    enable = false;
    settings.copy_command = {
      command = "wl-copy";
      args = [];
    };
  };
}
