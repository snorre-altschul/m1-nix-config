{ ... }:
{
  age.secrets.openai-key.file = ../secrets/openai-key.age;
  age.identityPaths = [ "/persist/system/home/nixos/.ssh/id_ed25519" ];
}
