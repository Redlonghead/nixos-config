{ pkgs, configVars, configLib, ... }:

{
  services.syncthing = {
    enable = true;
    user = configVars.userSettings.username;
    dataDir = "/home/" + configVars.userSettings.username;
    configDir = "/home/" + configVars.userSettings.username + "/.config/syncthing/";
  };

  environment.systemPackages = [
    (pkgs.writeScriptBin "syncthing" "xdg-open https://127.0.0.1:8384")
  ];
}
