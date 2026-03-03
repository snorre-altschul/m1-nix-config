{inputs, ...}: {
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "14:30";
    flake = inputs.self.outPath;
    flags = [
      "-L"
    ];
  };
}
