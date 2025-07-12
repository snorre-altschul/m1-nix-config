{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      factorio =
        (super.factorio.override {
          versionsJson = ./factorio-versions.json;
        }).overrideAttrs
          {
            meta.platforms = [ "aarch64-linux" ];
          };
    })
  ];

  system.extraDependencies = [
    pkgs.factorio.src
  ];
  environment.systemPackages = [
    pkgs.factorio
  ];
}
