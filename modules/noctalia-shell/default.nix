{lib,...}: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = builtins.readFile ./noctalia-config.toml;
  };
  systemd.user.services.niri-flake-polkit = lib.mkForce {};
}
