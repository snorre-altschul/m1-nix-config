{
  pkgs,
  stdenv,
}: let
  stdenv2 =
    stdenv
    // {
      hostPlatform.system = "x86_64-linux";
    };

  factorio = (pkgs.factorio-space-age.override {stdenv = stdenv2;}).overrideAttrs (_old: {
    meta.platforms = ["aarch64-linux"];
  });
in {
  environment.systemPackages = [
    factorio
  ];

  system.extraDependencies = [
    factorio.src
  ];
}
