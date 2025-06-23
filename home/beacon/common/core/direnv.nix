{
  pkgs,
  ...
}:

{
  services.lorri = {
    enable = true;
    package = pkgs.lorri;
  };

  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = true;
    enableZshIntegration = true;
  };
}
