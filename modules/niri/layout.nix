{ ... }:
{
  programs.niri.settings.layout = {
    gaps = 8;

    preset-column-widths = [
      { proportion = 1. / 3.; }
      { proportion = 1. / 2.; }
      { proportion = 2. / 3.; }
    ];

    border = {
      width = 1;
    };
  };
}
