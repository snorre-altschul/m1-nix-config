_inputs: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        pad = "4x4";
        term = "xterm-256color";
      };
      security.osc52 = "enabled";
    };
  };

  home.sessionVariables.TERM = "xterm";
  home.sessionVariables.TERMINAL = "footclient";
  home.sessionVariables.TERMCMD = "footclient";

  stylix.opacity.terminal = 0.8;
}
