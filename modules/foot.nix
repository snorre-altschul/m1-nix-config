{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "4x4";
      };
    };
  };

  home.sessionVariables.TERM = "xterm";
  home.sessionVariables.TERMINAL = "foot";
  home.sessionVariables.TERMCMD = "foot";
}
