{inputs, ...}: {
  programs.niri.settings.input = with inputs.niri-flake.lib.kdl; {
    keyboard = {
      xkb = {
        layout = "us";
        # variant = "colemak_dh";

        options = builtins.concatStringsSep "\n" [
          "caps:escape"
        ];
      };
      repeat-delay = 300;
      repeat-rate = 50;
    };
    touchpad = {
      tap = true;
      natural-scroll = true;
      dwt = true;
    };
    mouse = {
      accel-profile = "flat";
      accel-speed = 0.2;
    };
    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "10%";
    };
  };
}
