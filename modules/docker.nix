_: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    enableOnBoot = false;
  };

  users.users.nixos.extraGroups = [
    "docker"
  ];
  boot.binfmt.emulatedSystems = ["x86_64-linux"];
}
