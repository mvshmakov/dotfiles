#!/usr/bin/env sh
#
# macOS `defaults` that nix-darwin cannot express. Everything else moved to
# nix-darwin/.config/nix-darwin/modules/darwin/system.nix (system.defaults.*,
# time.timeZone, the ~/screenshots directory and `chflags nohidden ~/Library`)
# and is applied on every `darwin-rebuild switch`.

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in.
# `-currentHost` (ByHost preferences) has no nix-darwin option.
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "macOS setup completed!"
