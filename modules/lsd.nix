{...}: {
  programs.lsd = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish.enable = true;
}
