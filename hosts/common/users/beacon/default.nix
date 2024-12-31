{
  lib,
  configVars,
  config,
  pkgs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{
  # Define a user account.
  sops.secrets."users/beacon/pass".neededForUsers = true;
  users.mutableUsers = false; # required for sops

  users.users.beacon = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/beacon/pass".path;
    description = "Connor";
    packages = [ pkgs.home-manager ];

    extraGroups =
      [
        "wheel"
      ]
      ++ ifTheyExist [
        "audio"
        "video"
        "docker"
        "git"
        "networkmanager"
      ];

    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

    shell = pkgs.zsh; # default shell
  };

  # home-manager.users.beacon = import (configLib.relativeToRoot "home/beacon/${config.networking.hostName}.nix");

  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];

  # Default tools on all systems
  programs.zsh.enable = true;
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    just
    killall
    swaybg
  ];

}
