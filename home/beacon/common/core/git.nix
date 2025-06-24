{
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Redlonghead";
    userEmail = "git@beardit.net";
    signing = {
      signByDefault = true;
      key = "/home/beacon/.ssh/id_beacon.pub";
    };
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/beacon/.dotfiles";
      gpg.format = "ssh";
      diff.colorMoved = "zebra";
    };

    delta = {
      enable = true;
      package = pkgs.delta;
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
