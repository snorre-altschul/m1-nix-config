{self, ...}: {
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = ["14:30"];
    flake = self.outPath;
    flags = [
      "-L"
    ];
  };
}
