_: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "4x4";
      };
      security.osc52 = "enabled";
    };
  };

  home.sessionVariables.TERM = "xterm";
  home.sessionVariables.TERMINAL = "foot";
  home.sessionVariables.TERMCMD = "foot";

  stylix.opacity.terminal = 0.8;
}
