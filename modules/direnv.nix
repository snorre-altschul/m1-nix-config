_: {
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    loadInNixShell = true;
    silent = true;
    nix-direnv = {
      enable = true;
    };
  };
}
