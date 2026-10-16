{username, ...}: {
  system.defaults = {
    NSGlobalDomain = {
      # https://superuser.com/a/1274941
      # TODO is there a way to turn off NSAutomaticTextCompletionEnabled also?
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;

      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";

      AppleICUForce24HourTime = true;

      NSAutomaticWindowAnimationsEnabled = false;
      NSWindowResizeTime = 0.05;

      # Expand the save/print dialogs by default instead of the tiny sheet.
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;

      "com.apple.keyboard.fnState" = true;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.15;
      tilesize = 64;
      show-recents = false;
      mru-spaces = false;
      expose-group-apps = true;
      # Disable hot corners. For more options:
      # https://github.com/nix-darwin/nix-darwin/blob/4cff07de/modules/system/defaults/dock.nix#L417
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      FXPreferredViewStyle = "Nlsv"; # List view
      FXDefaultSearchScope = "SCcf"; # Current folder
      FXEnableExtensionChangeWarning = false;
    };

    # TODO disable some of those, I actually like the haptic touchpad
    trackpad = {
      Clicking = false; # tap to click
      TrackpadRightClick = true; # two-finger secondary click
      FirstClickThreshold = 0; # light
      SecondClickThreshold = 0; # light
    };

    screencapture = {
      location = "/Users/${username}/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };
  };
}
