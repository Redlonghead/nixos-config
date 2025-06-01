{
  config,
  lib,
  pkgs,
  inputs,
  configVars,
  ...
}:

let
  themePath =
    "../../../../../../themes"
    + ("/" + configVars.userSettings.theme + "/" + configVars.userSettings.theme)
    + ".yaml";
  themePolarity = lib.removeSuffix "\n" (
    builtins.readFile (
      ./. + "../../../../../../themes" + ("/" + configVars.userSettings.theme) + "/polarity.txt"
    )
  );
  backgroundUrl = builtins.readFile (
    ./. + "../../../../../../themes" + ("/" + configVars.userSettings.theme) + "/backgroundurl.txt"
  );
  backgroundSha256 = builtins.readFile (
    ./. + "../../../../../../themes/" + ("/" + configVars.userSettings.theme) + "/backgroundsha256.txt"
  );
in
{

  imports = [ inputs.stylix.homeModules.stylix ];

  home.file.".currenttheme".text = configVars.userSettings.theme;
  stylix.autoEnable = false;
  stylix.polarity = themePolarity;
  stylix.image = pkgs.fetchurl {
    url = backgroundUrl;
    sha256 = backgroundSha256;
  };
  stylix.base16Scheme = ./. + themePath;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
    };
    serif = {
      package = pkgs.nerd-fonts.fira-code;
    };
    sansSerif = {
      package = pkgs.nerd-fonts.fira-code;
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji-blob-bin;
    };
    sizes = {
      terminal = 18;
      applications = 12;
      popups = 12;
      desktop = 12;
    };
  };

  stylix.targets.kde.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.gtk.enable = true;

  home.file = {
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
