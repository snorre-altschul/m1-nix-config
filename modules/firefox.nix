{ ... }:
{
  imports = [
    (import ./firefox-generic.nix {
      name = "Firefox";
      package = "firefox";
    })
  ];
}
