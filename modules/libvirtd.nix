{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
    };
  };
}
