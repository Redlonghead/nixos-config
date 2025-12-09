{
  pkgs,
  config,
  ...
}:

let
  sColor = config.lib.stylix.colors;
in
{
  stylix.targets.lazygit.enable = false;

  programs = {
    git = {
      enable = true;
      package = pkgs.git;
      signing = {
        format = "ssh";
        signByDefault = true;
        key = "/home/beacon/.ssh/id_beacon.pub";
      };

      settings = {
        user.name = "Redlonghead";
        user.email = "git@beardit.net";
        init.defaultBranch = "main";
        diff.colorMoved = "zebra";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };

    delta = {
      enable = true;
      package = pkgs.delta;
      enableGitIntegration = true;
    };

    lazygit = {
      enable = true;
      package = pkgs.lazygit;
      settings = {
        nerdFontsVersion = "3";
        os = {
          editPreset = "vscode";
          openLink = "floorp {{link}}";
          copyToClipboardCmd = "wl-copy {{text}}";
        };
        gui.theme = {
          activeBorderColor = [
            sColor.base07
            "bold"
          ];
          inactiveBorderColor = [ sColor.base04 ];
          searchingActiveBorderColor = [
            sColor.base02
            "bold"
          ];
          optionsTextColor = [ sColor.base06 ];
          selectedLineBgColor = [ sColor.base03 ];
          cherryPickedCommitBgColor = [ sColor.base02 ];
          cherryPickedCommitFgColor = [ sColor.base03 ];
          unstagedChangesColor = [ sColor.base08 ];
          defaultFgColor = [ sColor.base05 ];
        };
      };
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
    text = "${config.programs.git.settings.user.name} namespaces=\"git\" ${builtins.readFile ../../../../hosts/common/users/beacon/common/keys/beacon.pub}";
  };

}
