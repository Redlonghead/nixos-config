{
  lib,
  pkgs,
  inputs,
  configVars,
  ...
}:

let
  themePath = (./. + "../../../../themes/${configVars.userSettings.theme}");
  themePolarity = lib.removeSuffix "\n" (builtins.readFile "${themePath}/polarity.txt");
  backgroundUrl = builtins.readFile "${themePath}/backgroundurl.txt";
  backgroundSha256 = builtins.readFile "${themePath}/backgroundsha256.txt";
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${themePath}/theme.yaml";
    polarity = themePolarity;

    image = pkgs.fetchurl {
      url = backgroundUrl;
      sha256 = backgroundSha256;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    opacity.terminal = 0.75;

    overlays.enable = true;

    # fonts = {
    #   monospace = {
    #     package = pkgs.nerd-fonts.fira-code;
    #   };
    #   serif = {
    #     package = pkgs.nerd-fonts.fira-code;
    #   };
    #   sansSerif = {
    #     package = pkgs.nerd-fonts.fira-code;
    #   };
    #   emoji = {
    #     name = "Noto Color Emoji";
    #     package = pkgs.noto-fonts-emoji-blob-bin;
    #   };
    # };

    targets = {
      nixos-icons.enable = true;
      lightdm.enable = true;
      console.enable = true;
    };
  };
}
