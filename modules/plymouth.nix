{ pkgs, ... }:
let
  package = pkgs.stdenv.mkDerivation {
    name = "plymouth-modern-bgrt";
    version = "1.0.0";
    src = pkgs.fetchFromGitea {
      domain = "git.spoodythe.one";
      owner = "spoody";
      repo = "plymouth-bgrt";
      rev = "80acc567bcc4e1d1f6bc82711768843e185421b6";
      hash = "sha256-/ig+PbHrkC6+a0M8CywduwtbNYq2RFmnnh0mk2wr0XQ=";
    };
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plymouth/themes/plymouth-modern-bgrt
      cp -r $src/theme/* $out/share/plymouth/themes/plymouth-modern-bgrt/

      runHook postInstall
    '';
  };
in
{
  boot.plymouth.enable = true;
  boot.loader.grub.timeoutStyle = "hidden";
  boot.loader.timeout = 5;
  boot.loader.systemd-boot.consoleMode = "max";
  # boot.plymouth.logo = ./boot/m1n1-bootloader-splash.png;
  stylix.targets.plymouth.enable = false;
  boot.plymouth.themePackages = [package];
  boot.plymouth.theme = "plymouth-modern-bgrt";
  boot.plymouth.logo = ./plymouth-logo.png;
  boot.kernelParams = [
    "loglevel=2"
    "udev.log_priority=2"
    "quiet"
    "splash"
  ];
}
