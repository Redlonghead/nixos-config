{
  pkgs,
  config,
  ...
}:

{
  stylix.targets.lazygit.enable = true;

  programs = {
    git = {
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
        diff.colorMoved = "zebra";
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };

      delta = {
        enable = true;
        package = pkgs.delta;
      };
    };

    lazygit = {
      enable = true;
      package = pkgs.lazygit;
    };

    zsh.shellAliases = {
      ga = "git add";
      gs = "git status";
      gc = "git commit -m";
      gp = "git push";
      gpl = "git pull";
      lg = "lazygit";
    };
  };

  home.file."allowed_signers" = {
    target = ".ssh/allowed_signers";
    text = "${config.programs.git.userName} namespaces=\"git\" ${builtins.readFile ../../../../hosts/common/users/beacon/common/keys/beacon.pub}";
  };

}
