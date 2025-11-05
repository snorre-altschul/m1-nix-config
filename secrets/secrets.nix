let
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfQLOKUnOARUAs8X1EL1GRHoCQ0oMun0vzL7Z78yOsM nixos@nixos";
in {
  "openai-key.age".publicKeys = [nixos];
}
