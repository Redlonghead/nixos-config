{ inputs, pkgs, config, configVars, ... }:

{

  sops = {
    secrets = {
      # add secrets to be extracted under /run with root priv by default
      "syncthing/${config.networking.hostName}/key" = {
        owner = configVars.userSettings.username;
        group = "syncthing";
      };

      "syncthing/${config.networking.hostName}/cert" = {
        owner = configVars.userSettings.username;
        group = "syncthing";
      };

    };

  };

  services.syncthing = {
    enable = true;
    user = configVars.userSettings.username;
    dataDir = "/home/${configVars.userSettings.username}";
    configDir = "/home/${configVars.userSettings.username}/.config/syncthing/";

    # FIXME Issue #326704 on nixpkg for needing to set
    # services.syncthing.overrideDevices = false
    # when declaring devices in nixos config
    overrideDevices = false;

    key = config.sops.secrets."syncthing/${config.networking.hostName}/key".path;
    cert = config.sops.secrets."syncthing/${config.networking.hostName}/cert".path;

    settings = {
      devices = { "CB-SNAS-01" = { id = "0AM0X7P-J0EACFU-HCJMJER-ZEBN7DK-KE7TMBX-YEZTM4U-Y22JDPP-KIPC3QU"; }; };
      folders = {
        "CB-SRC" = {
          path = "~/src";
          devices = [ "CB-SNAS-01" ];
          ignorePerms = false;
        };
        "CB-Documents" = {
          path = "~/Documents";
          devices = [ "CB-SNAS-01" ];
        };
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 ];
  };

  environment.systemPackages = [
    (pkgs.writeScriptBin "syncthing" "xdg-open https://127.0.0.1:8384")
  ];
}
