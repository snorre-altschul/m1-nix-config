_: {
  specialisation.work.configuration = {
    virtualisation.docker = {
      enable = false;
      storageDriver = "btrfs";
      enableOnBoot = false;
    };

    users.users.nixos.extraGroups = [
      "docker"
    ];
  };
}
