{lib, ...}: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = lib.mkForce <| builtins.readFile ./noctalia-config.toml;
  };

  systemd.user.services.niri-flake-polkit = lib.mkForce {};
}
