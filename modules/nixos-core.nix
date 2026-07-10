{
  system.nixos-core = {
    enable = true;
  };
  boot.initrd.systemd.enable = false;
  boot.loader.initScript.enable = false;
  system.etc.overlay.enable = false;
  systemd.sysusers.enable = false;
}
