{
  lib,
  pkgs,
  inputs,
  configVars,
  ...
}:

let
  themePath =
    "../../../../themes/"
    + configVars.userSettings.theme
    + "/"
    + configVars.userSettings.theme
    + ".yaml";
  themePolarity = lib.removeSuffix "\n" (
    builtins.readFile (
      ./. + "../../../../themes" + ("/" + configVars.userSettings.theme) + "/polarity.txt"
    )
  );
  myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  backgroundUrl = builtins.readFile (
    ./. + "../../../../themes" + ("/" + configVars.userSettings.theme) + "/backgroundurl.txt"
  );
  backgroundSha256 = builtins.readFile (
    ./. + "../../../../themes/" + ("/" + configVars.userSettings.theme) + "/backgroundsha256.txt"
  );
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.autoEnable = true;
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
  };

  stylix.targets.lightdm.enable = true;
  services.xserver.displayManager.lightdm = {
    greeters.slick.enable = true;
    greeters.slick.theme.name = myLightDMTheme;
  };
  stylix.targets.console.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

}
