{ pkgs, ... }:

{

  imports = [
    ./oh-my-posh.nix
  ];

  programs.zsh = {
    enable = true;

    # relative to ~
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    autosuggestion.enable = true;
    history.size = 10000;
    history.share = true;

    #FIXME overlays for pkgs are not working :/
    plugins = [
      {
        name = "zsh-term-title";
        src = "${pkgs.zsh-term-title}/share/zsh/zsh-term-title/";
      }
      {
        name = "cd-gitroot";
        src = "${pkgs.cd-gitroot}/share/zsh/cd-gitroot";
      }
    ];

    shellAliases = {
      la = "ls -la";
      ll = "ls -l";
      ".." = "cd ..";
      cl = "clear";
      ncc = "cd ~/src/nixos-config";
      nsc = "cd ~/src/nixos-secrets";
    };
  };
}
