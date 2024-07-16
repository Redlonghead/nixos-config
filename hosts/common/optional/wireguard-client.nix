{ pkgs, lib, config, configVars, ... }:

{

  #TODO Make into nixosModule in nixos-secrets
  sops = {
    secrets = {
      "wireguard/${config.networking.hostName}/ip" = { };
      "wireguard/${config.networking.hostName}/priv-key" = { };
      "wireguard/${config.networking.hostName}/pub-key" = { };
      "wireguard/domain" = { };
    };

    templates."wg0.conf" = {
      content = "[Interface]
PrivateKey = ${config.sops.placeholder."wireguard/${config.networking.hostName}/priv-key"}
Address = ${config.sops.placeholder."wireguard/${config.networking.hostName}/ip"}

[Peer]
PublicKey = ${config.sops.placeholder."wireguard/${config.networking.hostName}/pub-key"}
Endpoint = ${config.sops.placeholder."wireguard/domain"}
AllowedIPs = 0.0.0.0/0";
      owner = configVars.userSettings.username;
      path = "/home/${configVars.userSettings.username}/.config/wireguard/wg0.conf";
    };
  };

  # Need to run this
  # nmcli connection import type wireguard file ${config.sops.templates."wg0.conf".path}

  # system.activationScripts = lib.mkDefault {
  #   stdio.text = "nmcli connection import type wireguard file ${config.sops.templates."wg0.conf".path}";
  # };

}
