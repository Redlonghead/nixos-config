{ config, pkgs, configVars, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Redlonghead";
    userEmail = configVars.userSettings.git-email;
    signing = {
      signByDefault = true;
      key = "/home/" + configVars.userSettings.username + "/.ssh/id_beacon.pub";
    };
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/" + configVars.userSettings.username + "/.dotfiles";
      gpg.format = "ssh";
      # filter.flake-redact.smudge = "sh ${configVars.userSettings.dotfilesDir}/user/app/git/filters/flake-redact-smudge.sh";
      # filter.flake-redact.clean = "sh ${configVars.userSettings.dotfilesDir}/user/app/git/filters/flake-redact-clean.sh";
    };
  };

  programs.lazygit = {
    enable = true;
    package = pkgs.lazygit;
  };

  #TODO Add script files that takes out user and system settings from flake.nix 

  # Need also .gitattributes file

  # This script just taks whats in the 
  # systemSettings & userSettings in the flake.nix
  # and makes it a default setting to not change the repo"


  # wm = "hyprland";
  # bootMode = "uefi";
  # bootMountPath = "/boot";
  # grubDevice = "";
  # timezone = "America/Chicago";
  # locale = "en_US.UTF-8";
  # system = "x86_64-linux";

  # name = "Connor Beard";
  # email = SOPS.VAR;
  # theme = "uwunicorn-yt";
  # browser = "firefox";
  # editor = "vscode";
  # font = "FiraCode";

  programs.zsh.shellAliases = {
    ga = "git add";
    gs = "git status";
    gc = "git commit -m";
    gp = "git push";
    gpl = "git pull";
    lg = "lazygit";
  };

}
