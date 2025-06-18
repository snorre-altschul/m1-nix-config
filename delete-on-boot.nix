{
  lib,
  persistExtraDirectories ? [ ],
  persistExtraFiles ? [ ],
  users,
  extraConfig ? { },
  ...
}:
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    # Prepare temporary folder
    mkdir /btrfs_tmp

    # Mount unencrypted partition in temp folder
    mount /dev/mapper/cryptroot /btrfs_tmp

    # Check if root subvolume exists in partition
    if [[ -e /btrfs_tmp/root ]]; then
      # If a folder for old roots doesnt exist we create one
      mkdir -p /btrfs_tmp/old_roots
      # Get timestamp for naming roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      # Move old root into folder
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    # Delete old roots older than 30 days
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    # Create new root
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  # Dont nuke all the files. We wanna keep something
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/iwd"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx, g=rx, o=";
      }
    ] ++ persistExtraDirectories;

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ] ++ persistExtraFiles;

    inherit users;
  };

  # environment.etc = {
  #   "group".source = "/persist/system/etc/group";
  #   "passwd".source = "/persist/system/etc/passwd";
  #   "shadow".source = "/persist/system/etc/shadow";
  # };

  programs.fuse.userAllowOther = true;
}
