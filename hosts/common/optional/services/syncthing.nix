{ inputs, pkgs, config, ... }:

{

  #TODO Relized after that I can just leave it in public so refactor back into public repo
  # And need to generlize it for when I add more hosts.
  imports = [ inputs.nixos-secrets.nixosModules.syncthing-CB-FW ];

  # Issue #326704 on nixpkg for needing to set
  # services.syncthing.overrideDevices = false
  # when declaring devices in nixos config

  environment.systemPackages = [
    (pkgs.writeScriptBin "syncthing" "xdg-open https://127.0.0.1:8384")
  ];
}
