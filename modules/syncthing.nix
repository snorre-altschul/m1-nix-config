{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "nixos";
    dataDir = "/home/nixos/.local/share/syncthing";
  };
}
