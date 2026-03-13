{
  name,
  package,
}: {
  config,
  lib,
  inputs,
  ...
}: let
  profiles = ["default" "work"];
in {
  # Automatically install textfox theme
  imports = [inputs.textfox.homeManagerModules.default];
  textfox = with config.stylix.base16Scheme.palette; {
    enable = true;
    inherit profiles;
    config = {
      background.color = base00;
      border = {
        color = base0A;
        width = "1px";
        transition = "0.2s ease";
        radius = "3px";
      };

      displayTitles = false;
      bookmarks.alignment = "left";

      font = {
        family = config.stylix.fonts.monospace.name;
        size = "15px";
        accent = base0F;
      };

      textTransform = "uppercase";
      extraConfig = "/* custom css here */";
    };
  };

  xdg.desktopEntries = lib.attrsets.mapAttrs' (
    profileName: _value:
      lib.attrsets.nameValuePair "${name} - ${profileName} profile" {
        name = "${name} - ${profileName} profile";
        genericName = "Web Browser";
        exec = "${package} --name ${package} --profile ${config.home.homeDirectory}/${config.programs.firefox.configPath}/${profileName} %U";
        terminal = false;
        categories = [
          "Application"
          "Network"
          "WebBrowser"
        ];
      }
  ) (builtins.removeAttrs config.programs.firefox.profiles ["default"]);

  stylix.targets.${package} = {
    enable = true;
    profileNames = profiles;
  };

  programs.firefox = {
    enable = true;
    package = inputs.nixpkgs-mesa.legacyPackages.aarch64-linux."${package}";

    profiles = let
      mkProfile = {
        search.engines = {
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ecosia".metaData.hidden = true;
          "facebook".metaData.hidden = true;
          "twitter".metaData.hidden = true;
          "youtube".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
          "reddit".metaData.hidden = true;
          "perplexity".metaData.hidden = true;
        };
        search.default = "ddg";
        search.privateDefault = "ddg";
        search.force = true;
        extensions.force = true;
      };
    in {
      default =
        mkProfile
        // {
          id = 0;
          name = "default";
        };
      work =
        mkProfile
        // {
          id = 1;
          name = "work";
          settings = {
            # "browser.newtabpage.pinned" = [
            #   {
            #     title = "GitHub";
            #     url = "https://github.com/portchain/eba";
            #   }
            #   {
            #     title = "JIRA";
            #     url = "https://portchain.atlassian.net/jira/your-work";
            #   }
            #   {
            #     title = "slack";
            #     url = "https://portchain.slack.com";
            #   }
            # ];
          };
        };
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
      Preferences = let
        lock-false = {
          Value = false;
          status = "locked";
        };
        fingerprinting = false;
      in {
        "javascript.options.baselinejit" = lock-false;
        "javascript.options.ion" = lock-false;
        "javascript.options.asmjs" = lock-false;
        "browser.ml.chat.enabled" = lock-false;
        "browser.ml.chat.page.footerBadg" = lock-false;
        "browser.ml.chat.page.menuBadge" = lock-false;
        "browser.ml.chat.shortcut" = lock-false;
        "browser.ml.chat.shortcuts.custo" = lock-false;
        "browser.ml.chat.sideba" = lock-false;
        "browser.ml.checkForMemory" = lock-false;
        "browser.ml.enable" = lock-false;
        "browser.ml.enabl" = lock-false;
        "browser.ml.linkPreview.shif" = lock-false;
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "network.cookie.lifetimePolicy" = 0;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = false;
        "privacy.resistFingerprinting" = fingerprinting;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = fingerprinting;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.download.useDownloadDir" = true;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.backup.enabled" = false;
        "signon.usernameOnlyForm.enabled" = false;
        "signon.rememberSignons" = false;
        "signon.schemeUpgrades" = false;
        "signon.showAutoCompleteFooter" = false;
        "signon.privateBrowsingCapture.enabled" = false;
        "signon.passwordEditCapture.enabled" = false;
        "signon.capture.inputChanges.enabled" = false;

        "services.sync.prefs.sync.browser.ml.chat.enabled" = lock-false;
        "services.sync.prefs.sync.browser.ml.chat.page.footerBadge" = lock-false;
        "services.sync.prefs.sync.browser.ml.chat.page.menuBadge" = lock-false;
        "services.sync.prefs.sync.browser.ml.chat.shortcut" = lock-false;
        "services.sync.prefs.sync.browser.ml.chat.shortcuts.custom" = lock-false;
        "services.sync.prefs.sync.browser.ml.chat.sidebar" = lock-false;
        "services.sync.prefs.sync.browser.ml.checkForMemory" = lock-false;
        "services.sync.prefs.sync.browser.ml.enable" = lock-false;
        "services.sync.prefs.sync.browser.ml.linkPreview.shift" = lock-false;
        "services.sync.prefs.sync.cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "services.sync.prefs.sync.cookiebanners.service.mode" = 2; # Block cookie banners
        "services.sync.prefs.sync.network.cookie.lifetimePolicy" = 0;
        "services.sync.prefs.sync.privacy.fingerprintingProtection" = fingerprinting;
        "services.sync.prefs.sync.privacy.resistFingerprinting" = fingerprinting;
        "services.sync.prefs.sync.privacy.trackingprotection.emailtracking.enabled" = true;
        "services.sync.prefs.sync.privacy.trackingprotection.socialtracking.enabled" = true;
        "services.sync.prefs.sync.signon.backup.enabled" = false;
        "services.sync.prefs.sync.signon.usernameOnlyForm.enabled" = false;
        "services.sync.prefs.sync.signon.schemeUpgrades" = false;
        "services.sync.prefs.sync.signon.showAutoCompleteFooter" = false;
        "services.sync.prefs.sync.signon.privateBrowsingCapture.enabled" = false;
        "services.sync.prefs.sync.signon.passwordEditCapture.enabled" = false;
        "services.sync.prefs.sync.signon.capture.inputChanges.enabled" = false;

        "services.sync.addons.ignoreUserEnabledChanges" = false;
        "services.sync.engine.addons" = false;
        "services.sync.engine.addresses" = false;
        "services.sync.engine.addresses.available" = false;
        "services.sync.engine.bookmarks" = false;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.creditcards.available" = false;
        "services.sync.engine.history" = false;
        "services.sync.engine.prefs" = false;
        "services.sync.engine.tabs" = false;
        "services.sync.log.appender.file.logOnError" = false;
        "services.sync.log.appender.file.logOnSuccess" = false;
        "services.sync.log.cryptoDebug" = false;
        "services.sync.prefs.dangerously_allow_arbitrary" = false;
        "services.sync.prefs.sync-seen.browser.newtabpage.activity-stream.section.highlights" = false;
        "services.sync.prefs.sync-seen.browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "services.sync.prefs.sync-seen.general.autoScroll" = false;
        "services.sync.prefs.sync-seen.media.eme.enabled" = false;
        "services.sync.prefs.sync.accessibility.blockautorefresh" = false;
        "services.sync.prefs.sync.accessibility.browsewithcaret" = false;
        "services.sync.prefs.sync.accessibility.typeaheadfind" = false;
        "services.sync.prefs.sync.accessibility.typeaheadfind.linksonly" = false;
        "services.sync.prefs.sync.addons.ignoreUserEnabledChanges" = false;
        "services.sync.prefs.sync.app.shield.optoutstudies.enabled" = false;
        "services.sync.prefs.sync.browser.contentblocking.category" = false;
        "services.sync.prefs.sync.browser.contentblocking.features.strict" = false;
        "services.sync.prefs.sync.browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "services.sync.prefs.sync.browser.ctrlTab.sortByRecentlyUsed" = false;
        "services.sync.prefs.sync.browser.discovery.enabled" = false;
        "services.sync.prefs.sync.browser.download.useDownloadDir" = false;
        "services.sync.prefs.sync.browser.firefox-view.feature-tour" = false;
        "services.sync.prefs.sync.browser.formfill.enable" = false;
        "services.sync.prefs.sync.browser.link.open_newwindow" = false;
        "services.sync.prefs.sync.browser.menu.showViewImageInfo" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.topsites" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includeBookmarks" =
          false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includeDownloads" =
          false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includeVisited" =
          false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.rows" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.topstories.rows" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSearch" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.topSitesRows" = false;
        "services.sync.prefs.sync.browser.newtabpage.enabled" = false;
        "services.sync.prefs.sync.browser.newtabpage.pinned" = false;
        "services.sync.prefs.sync.browser.pdfjs.feature-tour" = false;
        "services.sync.prefs.sync.browser.safebrowsing.downloads.enabled" = false;
        "services.sync.prefs.sync.browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "services.sync.prefs.sync.browser.safebrowsing.malware.enabled" = false;
        "services.sync.prefs.sync.browser.safebrowsing.phishing.enabled" = false;
        "services.sync.prefs.sync.browser.search.update" = false;
        "services.sync.prefs.sync.browser.startup.homepage" = false;
        "services.sync.prefs.sync.browser.startup.page" = false;
        "services.sync.prefs.sync.browser.startup.upgradeDialog.enabled" = false;
        "services.sync.prefs.sync.browser.tabs.loadInBackground" = false;
        "services.sync.prefs.sync.browser.tabs.warnOnClose" = false;
        "services.sync.prefs.sync.browser.tabs.warnOnOpen" = false;
        "services.sync.prefs.sync.browser.taskbar.previews.enable" = false;
        "services.sync.prefs.sync.browser.urlbar.maxRichResults" = false;
        "services.sync.prefs.sync.browser.urlbar.showSearchSuggestionsFirst" = false;
        "services.sync.prefs.sync.browser.urlbar.suggest.bookmark" = false;
        "services.sync.prefs.sync.browser.urlbar.suggest.engines" = false;
        "services.sync.prefs.sync.browser.urlbar.suggest.history" = false;
        "services.sync.prefs.sync.browser.urlbar.suggest.openpage" = false;
        "services.sync.prefs.sync.browser.urlbar.suggest.searches" = false;
        "services.sync.prefs.sync.browser.urlbar.suggest.topsites" = false;
        "services.sync.prefs.sync.dom.disable_open_during_load" = false;
        "services.sync.prefs.sync.dom.disable_window_flip" = false;
        "services.sync.prefs.sync.dom.disable_window_move_resize" = false;
        "services.sync.prefs.sync.dom.event.contextmenu.enabled" = false;
        "services.sync.prefs.sync.dom.security.https_only_mode" = false;
        "services.sync.prefs.sync.dom.security.https_only_mode_ever_enabled" = false;
        "services.sync.prefs.sync.dom.security.https_only_mode_ever_enabled_pbm" = false;
        "services.sync.prefs.sync.dom.security.https_only_mode_pbm" = false;
        "services.sync.prefs.sync.extensions.activeThemeID" = false;
        "services.sync.prefs.sync.extensions.update.enabled" = false;
        "services.sync.prefs.sync.general.autoScroll" = false;
        "services.sync.prefs.sync.intl.accept_languages" = false;
        "services.sync.prefs.sync.intl.regional_prefs.use_os_locales" = false;
        "services.sync.prefs.sync.layout.spellcheckDefault" = false;
        "services.sync.prefs.sync.media.autoplay.default" = false;
        "services.sync.prefs.sync.media.eme.enabled" = false;
        "services.sync.prefs.sync.media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "services.sync.prefs.sync.network.cookie.cookieBehavior" = false;
        "services.sync.prefs.sync.permissions.default.image" = false;
        "services.sync.prefs.sync.pref.downloads.disable_button.edit_actions" = false;
        "services.sync.prefs.sync.pref.privacy.disable_button.cookie_exceptions" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.cache" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.cookies" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.downloads" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.formdata" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.history" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.offlineApps" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.sessions" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown.siteSettings" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.cache" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.downloads" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.formdata" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
        "services.sync.prefs.sync.privacy.clearOnShutdown_v2.siteSettings" = false;
        "services.sync.prefs.sync.privacy.donottrackheader.enabled" = false;
        "services.sync.prefs.sync.privacy.globalprivacycontrol.enabled" = false;
        "services.sync.prefs.sync.privacy.reduceTimerPrecision" = true;
        "services.sync.prefs.sync.privacy.resistFingerprinting.reduceTimerPrecision.jitter" = false;
        "services.sync.prefs.sync.privacy.resistFingerprinting.reduceTimerPrecision.microseconds" = false;
        "services.sync.prefs.sync.privacy.sanitize.sanitizeOnShutdown" = false;
        "services.sync.prefs.sync.privacy.trackingprotection.cryptomining.enabled" = true;
        "services.sync.prefs.sync.privacy.trackingprotection.enabled" = false;
        "services.sync.prefs.sync.privacy.trackingprotection.fingerprinting.enabled" = fingerprinting;
        "services.sync.prefs.sync.privacy.trackingprotection.pbmode.enabled" = false;
        "services.sync.prefs.sync.privacy.userContext.enabled" = false;
        "services.sync.prefs.sync.privacy.userContext.newTabContainerOnLeftClick.enabled" = false;
        "services.sync.prefs.sync.security.default_personal_cert" = false;
        "services.sync.prefs.sync.services.sync.syncedTabs.showRemoteIcons" = false;
        "services.sync.prefs.sync.signon.autofillForms" = false;
        "services.sync.prefs.sync.signon.generation.enabled" = false;
        "services.sync.prefs.sync.signon.management.page.breach-alerts.enabled" = false;
        "services.sync.prefs.sync.signon.rememberSignons" = false;
        "services.sync.prefs.sync.spellchecker.dictionary" = false;
        "services.sync.prefs.sync.ui.osk.enabled" = false;
        "services.sync.sendVersionInfo" = false;
        "services.sync.syncedTabs.showRemoteIcons" = false;

        "services.sync.engine.passwords" = false;
        "webgl.disabled" = false;
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" =
          lock-false
          // {
            Value = true;
          };
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
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
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-anti-translate/latest.xpi";
          installation_mode = "force_installed";
        };
        "user-agent-switcher@ninetailed.ninja" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
          installation_mode = "force_installed";
        };
        "vimium-c@gdh1995.cn" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
          installation_mode = "force_installed";
        };
        "FirefoxColor@mozilla.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox_color/latest.xpi";
          installation_mode = "force_installed";
        };
        "@crw-extension-firefox" = {
          install_url = "https://github.com/FULU-Foundation/CRW-Extension/releases/download/v1.0.31/firefox-extension.zip";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
