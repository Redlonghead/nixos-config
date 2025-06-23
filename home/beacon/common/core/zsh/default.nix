{
  lib,
  pkgs,
  ...
}:

{
  programs = {
    zsh = {
      enable = true;

      # relative to ~
      dotDir = ".config/zsh";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      autosuggestion.enable = true;
      history.size = 10000;
      history.share = true;

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
        cl = "clear";
        ls = "eza";
        la = "eza -la";
        ll = "eza -l";
        ".." = "cd ..";
        ncc = "cd ~/src/nixos-config";
        nsc = "cd ~/src/nixos-secrets";
        ranger = "yazi";
        ff = "fastfetch";
        cat = "bat";
        j = "just";
        ts = "tailscale";
        tss = "tailscale status";
        tsd = "sudo tailscale dns status";
        nix = "_nix";
      };

      initContent = "
      # Calls nom only when build, shell, develop subcommands of nix are called.
      _nix() {
        case $1 in
          build)
            shift
            command nom build \"$@\";;
          shell)
            shift
            command nom shell \"$@\";;
          develop)
            shift
            command nom develop \"$@\";;
          *)
            command nix \"$@\";;
        esac
      }
      ";
    };

    oh-my-posh = {
      enable = true;
      package = pkgs.oh-my-posh;
      settings = lib.importJSON ./omp-config.json;
    };
  };
}
