{
  pkgs,
  lib,
  ...
}: let
  theme = pkgs.runCommand "stylix-plymouth" {} ''
    themeDir="$out/share/plymouth/themes/stylix"
    mkdir -p $themeDir

    ${lib.getExe' pkgs.imagemagick "convert"} \
      -background transparent \
      -bordercolor transparent \
      ${./boot/m1n1-bootloader-splash-128x128.png} \
      $themeDir/logo.png

    cp ${./plymouth.script} $themeDir/stylix.script

    echo "
    [Plymouth Theme]
    Name=Stylix
    ModuleName=script

    [script]
    ImageDir=$themeDir
    ScriptFile=$themeDir/stylix.script
    " > $themeDir/stylix.plymouth
  '';
in {
  boot.plymouth.enable = true;
  boot.loader.grub.timeoutStyle = "hidden";
  boot.loader.timeout = 5;
  boot.plymouth.logo = ./boot/m1n1-bootloader-splash-128x128.png;
  boot.plymouth.themePackages = [theme];
  boot.plymouth.theme = "stylix";
  stylix.targets.plymouth.enable = false;
  boot.kernelParams = [
    "loglevel=2"
    "udev.log_priority=2"
    "quiet"
    "splash"
  ];
}
