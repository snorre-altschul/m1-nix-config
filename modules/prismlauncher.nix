{ pkgs, lib, ... }:
{
  home.packages = [
    (
      (pkgs.prismlauncher.override {
        prismlauncher-unwrapped = (
          pkgs.prismlauncher-unwrapped.overrideAttrs (old: {
            src = pkgs.fetchFromGitHub {
              owner = "fn2006";
              repo = "PollyMC";
              tag = "8.0";
              hash = "sha256-DF1lxQHetDKZEpRrRZ0HQWqqMDAGNiTZoCJUARdXFSk=";
            };
            doCheck = false;
          })
        );
      }).overrideAttrs
      (super: {
        qtWrapperArgs = super.qtWrapperArgs ++ [
          "--prefix POLLYMC_JAVA_PATHS : ${
            lib.makeSearchPath "bin/java" (
              with pkgs;
              [
                jdk8
                jdk21
                jdk17
              ]
            )
          }"
        ];
      })
    )
    pkgs.mangohud
  ];
}
