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
        font = "${config.stylix.fonts.monospace.name}:size=${toString config.stylix.fonts.sizes.terminal}";
        dpi-aware = "no";
        include =
          pkgs.writeTextFile {
            name = "da-one-sea-fixed.ini";
            text = ''
              # base16-foot
              # Scheme name: Da One Sea
              # Scheme author: NNB (https://github.com/NNBnh)
              # Template author: Tinted Theming (https://github.com/tinted-theming)
              [colors-dark]
              foreground=ffffff
              background=22273d
              regular0=22273d # black
              regular1=fa7883 # red
              regular2=98c379 # green
              regular3=ff9470 # yellow
              regular4=6bb8ff # blue
              regular5=e799ff # magenta
              regular6=8af5ff # cyan
              regular7=ffffff # white
              bright0=878d96 # bright black
              bright1=fa7883 # bright red
              bright2=98c379 # bright green
              bright3=ff9470 # bright yellow
              bright4=6bb8ff # bright blue
              bright5=e799ff # bright magenta
              bright6=8af5ff # bright cyan
              bright7=ffffff # bright white
              16=ffc387
              17=b3684f
              18=374059
              19=525866
              20=c8c8c8
              21=ffffff
            '';
          }
          |> toString
          |> lib.singleton
          |> lib.mkForce;
      };
      security.osc52 = "enabled";
    };
  };

  home.sessionVariables.TERM = "xterm";
  home.sessionVariables.TERMINAL = "footclient";
  home.sessionVariables.TERMCMD = "footclient";

  stylix.opacity.terminal = 0.8;
}
