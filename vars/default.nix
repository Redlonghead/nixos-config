{ inputs, lib }:

{
  systemSettings = rec {
    profile = "personal/laptop"; #TODO remove
    wm = "hyprland";
    wmType = if (wm == "hyprland") then "wayland" else "x11";
    timezone = "America/Chicago";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";

    bootMode = "uefi";
    bootMountPath = "/boot";
    grubDevice = "";

  };

  userSettings = rec {
    name = "Connor Beard";
    email = ""; #TODO add nixos-secrets input
    git-email = "git@beardit.net";
    theme = "uwunicorn-yt";
    browser = "firefox";
    editor = "vscode";
    font = "FiraCode";
    username = "beacon"; #TODO remove??

    dotfilesDir = "/home/beacon/src/nixos-config";
  };
}
