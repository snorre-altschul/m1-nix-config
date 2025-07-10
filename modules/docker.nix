{ ... }:
{
  specialisation.work.configuration = {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      enableOnBoot = false;
    };

    users.users.nixos.extraGroups = [
      "docker"
    ];
  };
}
