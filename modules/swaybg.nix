{
  config,
  pkgs,
  lib,
  ...
}:
{
  systemd.user.services."swaybg" = {
    Unit = {
      Description = "SwayBG Wallpaper";
      Wants = [ "graphical.target" ];
      After = [ "graphical.target" ];
    };
    Install.WantedBy = [ "default.target" ];

    Service.ExecStart = pkgs.writeShellScript "start-swaybg" ''
      ${lib.getExe pkgs.swaybg} -i ${config.stylix.image}
    '';
    Service.Restart = "always";
    Service.Environment = [
      "WAYLAND_DISPLAY=wayland-1"
    ];
  };
}
