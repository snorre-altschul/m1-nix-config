{lib, ...}: {
  services.gnome-keyring.enable = lib.mkForce false;
  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      General = {
        AutoGeneratePasswordForNewEntries = true;
        ConfigVersion = 2;
      };

      Browser = {
        Enabled = true;
      };

      FdoSecrets = {
        Enabled = true;
      };

      GUI = {
        ApplicationTheme = "dark";
        CompactMode = true;
        MinimizeOnClose = true;
        MinimizeToTray = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-light";
      };

      PasswordGenerator = {
        Type = 1;
        WordCase = 2;
        WordSeparator = "-";
      };

      Security = {
        EnableCopyOnDoubleClick = true;
        IconDownloadFallback = true;
      };
    };
  };
}
