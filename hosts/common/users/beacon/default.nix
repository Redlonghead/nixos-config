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
  sops.secrets."users/${configVars.userSettings.username}/pass".neededForUsers = true;
  users.mutableUsers = false; # required for sops

  users.users.${configVars.userSettings.username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/${configVars.userSettings.username}/pass".path;
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

  # home-manager.users.${configVars.userSettings.username} = import (configLib.relativeToRoot "home/${configVars.userSettings.username}/${config.networking.hostName}.nix");

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
