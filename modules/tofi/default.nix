{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.tofi.enable = true;
  programs.tofi.package = pkgs.tofi.overrideAttrs (_old: {
    patches = [./fix_centering.patch];
  });

  programs.tofi.settings = {
    width = "35%";
    height = "25%";
    border-width = 1;
    outline-width = 0;
    corner-radius = 4;

    border-color = lib.mkForce config.stylix.base16Scheme.palette.base0A;
    outline-color = lib.mkForce config.stylix.base16Scheme.palette.base0A;
    selection-match-color = lib.mkForce config.stylix.base16Scheme.palette.base09;

    # padding-left = "35%";
    # padding-right = "30%";
    result-spacing = 16;
    num-results = 6;
    prompt-background-padding = 5;
    # text-cursor-tyle = "underscore";
    text-cursor-corner-radius = 1;
    hide-cursor = false;
    text-cursor = true;
    # font-size = lib.mkForce 18;
  };

  home.activation.regenerateTofiCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
    tofi_cache=${config.xdg.cacheHome}/tofi-drun
    [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
  '';
}
