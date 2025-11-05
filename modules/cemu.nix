{pkgs, ...}: {
  home.packages = [
    (pkgs.cemu.overrideAttrs {
      meta.platforms = ["aarch64-linux"];
    })
  ];
}
