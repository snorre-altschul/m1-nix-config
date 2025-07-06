{ pkgs, fetchUrl, ... }@inputs:
{
  nixpkgs.config.allowUnsupportedSystem = true;
  home.packages = [
    # (
    #   (pkgs.dwarf-fortress.override (old: {
    #     stdenv = {
    #       hostPlatform = {
    #         system = "x86_64-linux";
    #         isLinux = true;
    #       };
    #       mkDerivation = old.stdenv.mkDerivation;
    #     };
    #   }))
    # )
    pkgs.legacyPackages."x86_64-linux".dwarf-fortress
  ];
}
