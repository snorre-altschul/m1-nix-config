{ ... }:
{
  programs.niri.settings.layout = {
    gaps = 5;

    preset-column-widths = [
      { proportion = 1. / 2.; }
      { proportion = 1. / 2.; }
    ];

    border = {
      width = 1;
    };
  };
}
