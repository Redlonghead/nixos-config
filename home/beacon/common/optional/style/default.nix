{
  config,
  lib,
  pkgs,
  inputs,
  configVars,
  ...
}:

let
  themePath = (./. + "../../../../../../themes/${configVars.userSettings.theme}");
  themePolarity = lib.removeSuffix "\n" (builtins.readFile "${themePath}/polarity.txt");
  backgroundUrl = builtins.readFile "${themePath}/backgroundurl.txt";
  backgroundSha256 = builtins.readFile "${themePath}/backgroundsha256.txt";
in
{

  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = false;
    autoEnable = false;
    polarity = themePolarity;
    image = pkgs.fetchurl {
      url = backgroundUrl;
      sha256 = backgroundSha256;
    };
    base16Scheme = "${themePath}/theme.yaml";

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
    #   sizes = {
    #     terminal = 18;
    #     applications = 12;
    #     popups = 12;
    #     desktop = 12;
    #   };
    # };

    targets = {
      kde.enable = true;
      kitty.enable = true;
      gtk.enable = true;
    };
  };

  home.file = {
    ".currenttheme".text = configVars.userSettings.theme;

    ".config/qt5ct/colors/oomox-current.conf".source = config.lib.stylix.colors {
      template = builtins.readFile ./oomox-current.conf.mustache;
      extension = ".conf";
    };
    ".config/Trolltech.conf".source = config.lib.stylix.colors {
      template = builtins.readFile ./Trolltech.conf.mustache;
      extension = ".conf";
    };
    ".config/kdeglobals".source = config.lib.stylix.colors {
      template = builtins.readFile ./Trolltech.conf.mustache;
      extension = "";
    };
    ".config/qt5ct/qt5ct.conf".text = pkgs.lib.mkBefore (builtins.readFile ./qt5ct.conf);
  };

  qt = {
    enable = true;
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
}
