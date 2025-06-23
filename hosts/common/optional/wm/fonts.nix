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
    ubuntu_font_family
    terminus_font
  ];

}
