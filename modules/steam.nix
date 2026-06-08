{
  pkgs,
  inputs,
  ...
}: let
  muvm-steam = inputs.muvm-steam.packages."aarch64-linux";
  x86_64-packages = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs; [
    x86_64-packages.steam
    muvm-steam.muvm
    muvm-steam.muvm-steam
  ];
}
