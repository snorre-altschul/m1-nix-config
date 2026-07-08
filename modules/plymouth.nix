{pkgs, ...}: let
  package = pkgs.stdenv.mkDerivation {
    name = "custom-plymouth-theme";
    version = "1.0.0";
    script = ./plymouth.script;
    logo = ./boot/m1n1-bootloader-splash.png;

    phases = ["installPhase"];

    installPhase = ''
      themeDir=$out/share/plymouth/themes/custom
      mkdir -p $themeDir
      cp $script $logo $themeDir/
      echo "
      [Plymouth Theme]
      Name=custom
      ModuleName=script

      [script]
      ImageDir=$themeDir
      ScriptFile=$themeDir/plymouth.script
      " > $themeDir/custom.plymouth
    '';
  };
in {
  boot.plymouth.enable = true;
  boot.loader.grub.timeoutStyle = "hidden";
  boot.plymouth.logo = ./boot/m1n1-bootloader-splash.png;
  stylix.targets.plymouth.enable = true;
  stylix.targets.plymouth.colors.enable = false;
  stylix.targets.grub.enable = false;
  boot.plymouth.themePackages = [package];
  boot.plymouth.theme = "custom";
  boot.kernelParams = [
    "loglevel=3"
    "udev.log_priority=3"
    "quiet"
    "splash"
  ];
}
