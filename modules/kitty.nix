_: {
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };

  home.sessionVariables.TERM = "xterm";
  home.sessionVariables.TERMINAL = "kitty";
  home.sessionVariables.TERMCMD = "kitty";

  stylix.opacity.terminal = 0.8;
}
