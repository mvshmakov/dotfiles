# macOS system settings, migrated from home/scripts/macos.sh.
#
# Everything nix-darwin has a typed option for uses it; the rest goes through
# `CustomUserPreferences` (defaults write <domain>) or
# `CustomSystemPreferences` (sudo defaults write /Library/Preferences/<domain>).
# Not migratable and left in macos.sh: `defaults -currentHost` writes.
{
  inputs,
  username,
  lib,
  ...
}:
{
  # The machine is already on Europe/Berlin (macos.sh still said Moscow);
  # `sudo systemsetup -listtimezones` for other values
  time.timeZone = "Europe/Berlin";

  # Touch ID (and Apple Watch) for sudo; `reattach` makes it work inside
  # tmux/screen by re-attaching the process to the user's GUI session.
  # Survives macOS updates, unlike a hand-edited /etc/pam.d/sudo.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system = {
    # Used for backwards compatibility, read the changelog before changing:
    # `darwin-rebuild changelog`
    stateVersion = 7;

    # Recorded in `darwin-version --json`; null while the tree is dirty
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    defaults = {
      NSGlobalDomain = {
        # Repeat keys on hold more often
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        # Expand the save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        # Show all filename extensions
        AppleShowAllExtensions = true;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
      };

      finder = {
        # Show hidden files, path bar, folders first, POSIX path in the title
        AppleShowAllFiles = true;
        ShowPathbar = true;
        _FXSortFoldersFirst = true;
        _FXShowPosixPathInTitle = true;
        # Search the current folder by default
        FXDefaultSearchScope = "SCcf";
        # No warning when changing a file extension
        FXEnableExtensionChangeWarning = false;
      };

      # Disable the "Are you sure you want to open this application?" dialog
      LaunchServices.LSQuarantine = false;

      screencapture = {
        # Directory is created in postActivation below
        location = "/Users/${username}/screenshots";
        type = "png";
      };

      # Domains without typed options (`defaults write <domain> <key> <value>`)
      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleLanguages = [
            "en-RU"
            "ru-RU"
          ];
          AppleLocale = "en_RU@currency=EUR";
        };
        # Avoid creating .DS_Store files on network or USB volumes
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        # Only use UTF-8 in Terminal.app
        "com.apple.terminal".StringEncodings = [ 4 ];
        # Don't display the prompt when quitting iTerm
        "com.googlecode.iterm2".PromptOnQuit = false;
        # Check for, download and install (security) updates automatically
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          AutomaticDownload = 1;
          CriticalUpdateInstall = 1;
        };
        # Turn on App Store app auto-update
        "com.apple.commerce".AutoUpdate = true;
        # Apple Mail: "Manage plugins" button (GPG plugin), attachments as files
        "com.apple.mail" = {
          EnableBundles = true;
          BundleCompatibilityVersion = 4;
          DisableInlineAttachmentViewing = true;
        };
        # Thin strokes on retina; Alacritty's default smoothing looks bold
        # https://github.com/alacritty/alacritty/issues/4616#issuecomment-1236413444
        "org.alacritty".AppleFontSmoothing = 0;
      };

      # `sudo defaults write /Library/Preferences/<domain>`
      CustomSystemPreferences = {
        # Show the input (language) menu on the login screen
        "com.apple.loginwindow".showInputMenu = true;
        # Mail plugins need this system-wide as well
        "com.apple.mail".EnableBundles = 1;
      };
    };

    # Runs as root at the end of every activation
    activationScripts.postActivation.text = ''
      # Screenshot target directory (macOS silently falls back to the Desktop
      # when it is missing)
      sudo --user=${lib.escapeShellArg username} -- mkdir -p /Users/${username}/screenshots
      # Show the ~/Library folder in Finder
      chflags nohidden /Users/${username}/Library
    '';
  };
}
