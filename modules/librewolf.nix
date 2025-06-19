{
  pkgs,
  config,
  lib,
  ...
}: {
  xdg.desktopEntries = lib.attrsets.mapAttrs' (
    name: value:
      lib.attrsets.nameValuePair "Librewolf - ${name} profile" {
        name = "Librewolf - ${name} profile";
        genericName = "Web Browser";
        exec = "librewolf --name librewolf --profile ${config.home.homeDirectory}/.librewolf/${name} %U";
        terminal = false;
        categories = [
          "Application"
          "Network"
          "WebBrowser"
        ];
      }
  ) (lib.attrsets.filterAttrs (name: _: !(name == "default")) config.programs.firefox.profiles);

  # stylix.targets.firefox.profileNames = [
  #   "default"
  #   "work"
  # ];

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf-wayland;

    configPath = ".librewolf";

    profiles = {
      default = {
        id = 0;
        name = "default";
      };
      work = {
        id = 1;
        name = "work";
        # settings =
        #   # config.programs.firefox.policies.Preferences //
        #    {
        #     "browser.newtabpage.pinned" = [
        #       {
        #         title = "GitHub";
        #         url = "https://github.com/portchain/eba";
        #       }
        #       {
        #         title = "JIRA";
        #         url = "https://portchain.atlassian.net/jira/your-work";
        #       }
        #     ];
        #   };
      };
    };

    policies = {
      # DisableTelemetry = true;
      # DisableFirefoxStudies = true;
      # EnableTrackingProtection = {
      #   Value = true;
      #   Locked = true;
      #   Cryptomining = true;
      #   Fingerprinting = true;
      # };
      # DisablePocket = true;
      # DisableFirefoxAccounts = true;
      # DisableAccounts = true;
      # DisableFirefoxScreenshots = true;
      # OverrideFirstRunPage = "";
      # OverridePostUpdatePage = "";
      # DontCheckDefaultBrowser = true;
      # DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
      # DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      # SearchBar = "unified"; # alternative: "separate"
      Preferences = let
        lock-false = {
          Value = false;
          status = "locked";
        };
      in {
        # "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        # "cookiebanners.service.mode" = 2; # Block cookie banners
        # "network.cookie.lifetimePolicy" = 0;
        # "privacy.clearOnShutdown.cookies" = false;
        # "privacy.clearOnShutdown.history" = false;
        # "privacy.donottrackheader.enabled" = true;
        # "privacy.fingerprintingProtection" = false;
        # "privacy.resistFingerprinting" = true;
        # "privacy.trackingprotection.emailtracking.enabled" = true;
        # "privacy.trackingprotection.enabled" = true;
        # "privacy.trackingprotection.fingerprinting.enabled" = true;
        # "privacy.trackingprotection.socialtracking.enabled" = true;
        # "webgl.disabled" = false;
        # "browser.contentblocking.category" = {
        #   Value = "strict";
        #   Status = "locked";
        # };
        # "extensions.pocket.enabled" = lock-false;
        # "extensions.screenshots.disabled" =
        #   lock-false
        #   // {
        #     Value = true;
        #   };
        # "browser.topsites.contile.enabled" = lock-false;
        # "browser.formfill.enable" = lock-false;
        # "browser.search.suggest.enabled" = lock-false;
        # "browser.search.suggest.enabled.private" = lock-false;
        # "browser.urlbar.suggest.searches" = lock-false;
        # "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        # "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        # "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        # "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        # "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        # "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        # "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        # "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        # "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        # "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # FUCK youtube ai translated titles
        "{458160b9-32eb-0f0c-8_d1-89ad3bdeb9dc}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-anti-translate/latext.xpi";
          installation_mode = "force_installed";
        };
        "vimium-c@gdh1995.cn" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
