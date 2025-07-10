{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Could use overrideAttrs but that would involve recompiling psst
    (
      let
        desktopItem = makeDesktopItem {
          categories = [
            "Audio"
            "AudioVideo"
          ];
          comment = "Spotify client with native GUI written in Rust, without Electron";
          desktopName = "Psst";
          exec = ".psst-gui-wrapped %U";
          icon = "psst";
          name = "Psst";
          startupWMClass = "psst-gui";
        };
      in
      stdenv.mkDerivation {
        pname = "psst-wrapped";
        version = psst.version;
        buildInputs = [ psst ];
        src = writeShellScriptBin ".psst-gui-wrapped" "WAYLAND_DISPLAY=\"\" ${lib.getExe psst}";
        installPhase = ''
          mkdir -p $out/bin
          cp $src/bin/.psst-gui-wrapped $out/bin/.psst-gui-wrapped
          runHook postInstall
        '';
        postInstall = ''
          install -Dm644 ${desktopItem}/share/applications/* -t $out/share/applications
        '';
        meta.mainProgram = ".psst-gui-wrapped";
      }
    )
  ];
}
