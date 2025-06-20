{ ... }:
{
  imports = [
    (import ./firefox-generic.nix {
      name = "Librewolf";
      package = "librewolf";
    })
  ];
  programs.firefox.configPath = ".librewolf";
}
