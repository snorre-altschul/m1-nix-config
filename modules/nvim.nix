{pkgs, ...}: {
  stylix.targets.nvf.enable = false;
  programs.nvf = {
    enable = true;
    settings = import ./nvim-configuration.nix {inherit pkgs;};
  };
}
