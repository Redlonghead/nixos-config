{
  lib,
  config,
  pkgs,
  ...
}:

let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive ../keys;
in
{
  imports = (lib.custom.scanPaths ./.);

  # Define a user account.
  sops.secrets."users/beacon/pass".neededForUsers = true;
  users.mutableUsers = false; # required for sops

  users.users.beacon = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/beacon/pass".path;
    description = "Connor";
    packages = [ pkgs.home-manager ];

    extraGroups = [
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

  # home-manager.users.beacon = import (lib.custom.relativeToRoot "home/beacon/${config.networking.hostName}.nix");

  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    droid-sans-mono
    geist-mono
  ];

  # Default tools on all systems
  programs = {
    zsh.enable = true;
    git.enable = true;
    nh.flake = lib.mkForce "/home/beacon/src/nixos-config";
  };

  environment.systemPackages = with pkgs; [
    killall
  ];

}
