{ config, pkgs, configVars, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Redlonghead";
    userEmail = "git@beardit.net";
    signing = {
      signByDefault = true;
      key = "/home/" + configVars.userSettings.username + "/.ssh/id_beacon.pub";
    };
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/" + configVars.userSettings.username + "/.dotfiles";
      gpg.format = "ssh";
    };
  };

  programs.lazygit = {
    enable = true;
    package = pkgs.lazygit;
  };

  programs.zsh.shellAliases = {
    ga = "git add";
    gs = "git status";
    gc = "git commit -m";
    gp = "git push";
    gpl = "git pull";
    lg = "lazygit";
  };

}
