# What stays in Homebrew: GUI apps (casks), Mac App Store apps and the few
# formulae that have no (working) nixpkgs equivalent on macOS. Everything
# else moved to nixpkgs in ../home/packages.nix. Casks stay in Homebrew on
# purpose: nixpkgs' darwin GUI apps miss code-signing/Spotlight/auto-update
# integration, so the community consensus is nix for CLI, casks for apps.
#
# nix-darwin renders this into a Brewfile and runs `brew bundle` on every
# `darwin-rebuild switch`. It requires Homebrew to be installed already
# (home/scripts/brew.sh does that).
#
# The comments are carried over from brew/.config/brew/Brewfile, which this
# file supersedes.
{ username, ... }:
{
  homebrew = {
    enable = true;
    user = username;

    onActivation = {
      # Uninstall everything not declared here (the formulae that moved to
      # nixpkgs, undeclared taps). "uninstall" rather than "zap": zap would
      # also delete the removed casks' preferences/app data.
      cleanup = "uninstall";
      autoUpdate = false;
      # Upgrades stay a manual `brew upgrade --greedy` (every switch would
      # otherwise download cask updates)
      upgrade = false;
    };

    # Point HOMEBREW_BUNDLE_FILE at the generated Brewfile so a manual
    # `brew bundle` acts on the same declaration (the export in .zprofile
    # still wins until it is removed in phase 2)
    global.brewfile = true;

    # Always upgrade auto-updating/unversioned casks too (the Brewfile used
    # HOMEBREW_UPGRADE_GREEDY=1 / HOMEBREW_CASK_OPTS="--greedy")
    greedyCasks = true;

    # Homebrew 6+ refuses formulae from untrusted third-party taps; `trusted`
    # marks them in the Brewfile (`brew trust --tap` is no longer needed)
    taps = [
      # yabai/skhd (author renamed koekeishiya -> asmvik)
      {
        name = "asmvik/formulae";
        trusted = true;
      }
      # ssh-askpass (GUI passphrase prompt for ssh-add/sudo)
      {
        name = "theseal/ssh-askpass";
        trusted = true;
      }
      {
        name = "kaplanelad/tap";
        trusted = true;
      }
      {
        name = "mvshmakov/spotlighter";
        trusted = true;
      }
      {
        name = "abue-ammar/tinycast";
        trusted = true;
      }
      # zathura (the tap moved from zegervdv/zathura to the homebrew-zathura org)
      {
        name = "homebrew-zathura/zathura";
        trusted = true;
      }
      # tailmux: one laptop on several tailnets at once (TUN mode)
      {
        name = "growlyx/tap";
        trusted = true;
      }
    ];

    brews = [
      # Needed by `brew bundle` itself for the masApps below
      "mas"

      # Window manager + hotkey daemon: kept in Homebrew on purpose. The
      # nixpkgs binaries are ad-hoc signed and change path on every update,
      # which makes macOS drop their Accessibility/Input Monitoring grants
      # after each rebuild (see ./window-manager.nix).
      "asmvik/formulae/yabai"
      {
        # --with-logging adds log files to the plist
        name = "asmvik/formulae/skhd";
        args = [ "with-logging" ];
      }

      # Not in nixpkgs
      "theseal/ssh-askpass/ssh-askpass"
      "kaplanelad/tap/shellfirm"
      "mvshmakov/spotlighter/spotlighter"
      # Joins the personal tailnet next to Tailscale.app (which stays on the
      # work tailnet). Homebrew only builds it; it is NOT run via brew
      # services (that executes a user-owned path as root and tailmux
      # re-execs on change). The daemon is the root LaunchDaemon
      # local.tailmux with a root-owned copy of the binary, installed by
      # home/scripts/tailmux-root-install.sh from tailmux/.config/tailmux/.
      # After `brew upgrade tailmux`, review the diff and re-run that script.
      "growlyx/tap/tailmux"
      # Marked unsupported on aarch64-darwin in nixpkgs
      "i2p"
      # inetutils (ftp/telnet) was dropped: unused, and `nc` covers the
      # port-poking use case

      # Was installed outside the Brewfile
      "unbound"

      # PDF and other docs reader. nixpkgs' zathura plugins all depend on
      # appstream, which does not compile on darwin (nixpkgs 26.05), so the
      # tap stays. The plugins must be linked into zathura's plugin dir:
      # https://github.com/zegervdv/homebrew-zathura#installation
      "homebrew-zathura/zathura/zathura"
      {
        name = "homebrew-zathura/zathura/zathura-djvu";
        postinstall = "mkdir -p $(brew --prefix zathura)/lib/zathura && ln -sf $(brew --prefix zathura-djvu)/libdjvu.dylib $(brew --prefix zathura)/lib/zathura/libdjvu.dylib";
      }
      {
        name = "homebrew-zathura/zathura/zathura-pdf-poppler";
        postinstall = "mkdir -p $(brew --prefix zathura)/lib/zathura && ln -sf $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib";
      }
    ];

    # Declared == installed. Casks from the old Brewfile that were no longer
    # installed (acrobat, chrome, edge, opera, tor, postman, whatsapp, vscode
    # stable, ea/gog, oversight, monitorcontrol, shottr, quicklook-json,
    # syntax-highlight, background-music, veracrypt, yubikey-manager,
    # free-gpgmail) were dropped instead of being reinstalled: disk is short.
    casks = [
      "1password"
      # The `op` CLI: kept as a cask so the app's biometric unlock keeps
      # working (it requires the AgileBits-signed binary in its location)
      "1password-cli"
      "alt-tab"
      # KDE Connect for Mac (pairs macOS, iOS, Android and Linux together)
      "soduto"
      "anydesk"
      "appcleaner"
      # Hold the command key a bit longer to get a list of all active shortcuts
      "keyclu"
      "crossover"
      "dash"
      # The only properly signed torrent client left (deluge/qbittorrent
      # casks were disabled by Gatekeeper deprecation)
      "transmission"
      "devtoys"
      "discord"
      "dotnet-sdk"
      # Contains both CLI and GUI (renamed from `docker`)
      "docker-desktop"
      # Nicest diagramming/drawing app
      "drawio"
      "fbreader"
      # Flipper Zero app
      "qflipper"
      # Free font builder
      "birdfont"
      # E-Book library
      "calibre"
      # Scientific papers library
      "mendeley-reference-manager"
      "inkscape"
      "gimp"
      # Grammar checking (renamed from `languagetool`)
      "languagetool-desktop"
      "hazeover"
      "keycastr"
      # Best archiving tool so far + helper to make it the default
      "keka"
      "kekaexternalhelper"
      "karabiner-elements"

      # Browsers
      # Same Chromium.app artifact and profile dir minus the Google
      # integrations (plain chromium cask was disabled by Gatekeeper)
      "ungoogled-chromium"
      "firefox"
      "brave-browser"
      "yandex"
      "browserstacklocal"

      # Terminal emulator (the only one with blur/ligatures besides iTerm2)
      "ghostty"
      # The best launchd inspector/editor
      "launchcontrol"

      # VPNs
      "cloudflare-warp"
      "tunnelblick"

      # Objective-See (objective-see.org) security apps
      "lulu"

      "libreoffice"
      "mqttfx"
      # The perfect open-source RSS reader
      "netnewswire"
      "ngrok"
      "numi"
      "obs"
      # Notarized, Apple Silicon-native multi-system emulator frontend
      "retroarch"
      "porting-kit"

      # Gaming
      "steam"
      "epic-games"
      "playonmac"

      # Crypto wallets
      "electrum"
      "monero-wallet"

      # QuickLook plugins (modern .appex ones)
      "qlmarkdown"
      # Renamed from `qlvideo`
      "quicklook-video"

      # Lightweight Raycast alternative
      "abue-ammar/tinycast/tinycast"
      "raspberry-pi-imager"

      # Messengers
      "microsoft-teams"
      "slack"
      "vk-messenger"

      # DB tools
      "dbeaver-community"
      # Renamed from `datasette`
      "datasette-desktop"

      # Editors + AI agents
      "visual-studio-code@insiders"
      "zed"
      # Codex lives inside the unified ChatGPT app since July 2026
      "chatgpt"

      # Desktop widgets
      "ubersicht"
      "stats"

      # Renamed from `wireshark`
      "wireshark-app"
      "virtualbox"

      "yandex-music"

      "figma"
      "zeplin"

      # FUSE implementation for Cryptomator mounts (macfuse is deprecated)
      "fuse-t"

      # Password managers / keys
      "keepassxc"

      # MeetingBar + Apple Calendar combo works best
      "meetingbar"

      # Renamed from `linear-linear`
      "linear"
      "obsidian"
      "notion"

      # Menu bar manager (actively maintained ice fork)
      "thaw"

      # Cloud mounts / backup
      "google-drive"
      "yandex-disk"
      "duplicati"
      "mountain-duck"
      # Creates a TmpFS disk in RAM on login
      "tmpdisk"
      "cryptomator"

      # Best todo list tracker
      "ticktick"

      # -----------------------------------------------------------------
      # Adopted from the machine state: installed, but absent from the
      # Brewfile (drift). Declared so that phase 2's `cleanup = "zap"` does
      # not silently remove them. REVIEW AND PRUNE - several duplicate a
      # declared app (ice vs thaw, raycast vs tinycast, kitty/iterm2 vs
      # ghostty, insomnia vs postman, telegram cask vs mas).
      # -----------------------------------------------------------------
      "android-file-transfer"
      "antigravity"
      "applite"
      "atuin-desktop"
      "claude"
      "claude-code"
      "copilot-cli"
      "firefox@developer-edition"
      "gcloud-cli"
      "github-copilot-app"
      "gpg-suite-no-mail"
      "grandperspective"
      "insomnia"
      "iterm2"
      "jordanbaird-ice@beta"
      "kitty"
      "macdroid"
      "microsoft-auto-update"
      "multipass"
      "ollama"
      "ollama-app"
      "omnidisksweeper"
      "onyx"
      "opencode-desktop"
      "pearcleaner"
      "poedit"
      "raycast"
      "redis-insight"
      "spotify"
      "telegram"
      "yubico-authenticator"
      "zoom"
    ];

    # `mas search <name>` for ids. Not-installed entries from the Brewfile
    # (DjVu Reader, UTM, GoPro Quik, Notchmeister, Telegram-as-mas) dropped.
    masApps = {

      # Browser manager (also $BROWSER)
      "Velja" = 1607635845;
      "Xcode" = 497799835;

      "Bitwarden" = 1352778147;
      "Amphetamine" = 937984704;
      "Dropover" = 1355679052;
      "GIPHY CAPTURE" = 668208984;

      "Keynote" = 409183694;

      "Pages" = 409201541;
      "Pocket" = 568494494;
      "Tailscale" = 1475387142;

      # Drift (installed, not in the Brewfile) - review and prune
      "AusweisApp" = 948660805;
      "KeePassium" = 1435127111;
      "Pasteboard Viewer" = 1499215709;
      "imo" = 1617395642;
      "WhatsApp 2" = 310633997;
      # Note: Keynote/Numbers/Pages are each installed twice with different
      # ids (409xxxxxx and 3613xxxxx); only the Brewfile ids are declared.
      "Numbers" = 409203825;
    };
  };
}
