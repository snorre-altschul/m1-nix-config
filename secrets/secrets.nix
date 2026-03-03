{lib, ...}: let
  public-keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfQLOKUnOARUAs8X1EL1GRHoCQ0oMun0vzL7Z78yOsM nixos@nixos"
  ];
in
  (builtins.readDir ./.)
  |> lib.attrsets.filterAttrs (name: value: (value == "regular") && (lib.hasSuffix ".age" name))
  |> lib.attrsets.mapAttrs (_name: _value: {publicKeys = public-keys;})
