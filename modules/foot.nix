{
  pkgs,
  lib,
  config,
  ...
}: {
  stylix.targets.foot.enable = lib.mkForce false;
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      colors-dark.alpha = config.stylix.opacity.terminal;
      main = {
        pad = "4x4";
        term = "xterm-256color";
        font = "${config.stylix.fonts.monospace.name}:size=10";
        dpi-aware = "no";
      };
      security.osc52 = "enabled";
    };
  };

  home.sessionVariables.TERM = "xterm";
  home.sessionVariables.TERMINAL = "footclient";
  home.sessionVariables.TERMCMD = "footclient";

  stylix.opacity.terminal = 0.8;
}
