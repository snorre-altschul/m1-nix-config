{inputs, ...}: {
  imports = [
    inputs.steam-asahi.nixosModules.default
  ];
  programs.steam-asahi.enable = true;
}
