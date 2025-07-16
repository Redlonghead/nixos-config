{
  pkgs,
  ...
}:

{

  stylix.targets.kitty.enable = true;

  programs = {
    kitty = {
      enable = true;
      package = pkgs.kitty;
    };

    zsh.shellAliases = {
      ksh = "kitten ssh";
    };
  };
}
