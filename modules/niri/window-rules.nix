{ inputs, lib, ... }:
{
  programs.niri.settings.window-rules = [
    {
      matches = [
        {
          app-id = "firefox$";
          title = "^Picture-in-Picture$";
        }
      ];
      open-floating = true;
    }
    {
      geometry-corner-radius = lib.genAttrs [
        "bottom-left"
        "bottom-right"
        "top-left"
        "top-right"
      ] (_: 4.);
      clip-to-geometry = true;
    }
    (
      let
        recording-color = "#ff0000";
      in
      {
        # Indicate screencasted windows with red colors.
        matches = [ { is-window-cast-target = true; } ];

        focus-ring = {
          inactive.color = recording-color;
          active.color = recording-color;
          width = 2;
          enable = true;
        };

        border = {
          inactive.color = recording-color;
          active.color = recording-color;
        };
      }
    )
  ];
}
