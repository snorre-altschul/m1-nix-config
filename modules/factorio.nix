{ pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      factorio =
        (super.factorio.override {
          versionsJson = ./factorio-versions.json;
          releaseType = "expansion";
        }).overrideAttrs
          (super: {
            installPhase =
              let
                desktopItem = pkgs.makeDesktopItem {
                  name = "factorio";
                  desktopName = "Factorio";
                  comment = "A game in which you build and maintain factories.";
                  exec = lib.getExe (
                    pkgs.writeShellScriptBin ".factorio-wrapped" ''
                      SDL_VIDEODRIVER=wayland PATH=$PATH:${pkgs.box64}/bin ${lib.getExe pkgs.muvm} --emu=box ${pkgs.mangohud}/bin/mangohud factorio
                    ''
                  );
                  icon = "factorio";
                  categories = [ "Game" ];
                };
                installPhase' = lib.strings.splitString "\n" super.installPhase;
              in
              builtins.concatStringsSep "\n" (
                (lib.lists.dropEnd 3 installPhase') ++ [ "ln -s ${desktopItem}/share/applications $out/share/" ]
              );
            buildInputs =
              super.buildInputs
              ++ (with pkgs; [
                box64
                muvm
                mangohud
                gamemode
              ]);
            meta.platforms = [ "aarch64-linux" ];
          });
    })
  ];

  system.extraDependencies = [
    pkgs.factorio.src
  ];

  environment.systemPackages = [
    pkgs.factorio
  ];
}
