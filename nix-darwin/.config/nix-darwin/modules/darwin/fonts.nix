# Fonts, installed into /Library/Fonts/Nix Fonts (replaces the font casks)
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Patched Nerd Fonts for the icons within the terminal. Not yet possible
    # to get rid of those: Alacritty does not support fallback fonts
    # https://github.com/alacritty/alacritty/issues/957
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.martian-mono
    nerd-fonts._0xproto
    # Icon-only patch to pair with unpatched fonts
    # https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
    nerd-fonts.symbols-only

    fira-code # Perfect
    jetbrains-mono # Perfect, but lacks the "---" ligature (nvim)
    source-code-pro

    # Product fonts
    nunito-sans
  ];
}
