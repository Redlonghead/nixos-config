{
  pkgs,
  ...
}:

{
  # Fonts are nice to have
  fonts.packages = with pkgs; [
    # Fonts
    nerd-fonts.inconsolata
    powerline
    iosevka
    font-awesome
    ubuntu-classic
    terminus_font
  ];

}
