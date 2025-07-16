{
  pkgs,
  ...
}:

{
  stylix.targets.rofi.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
}
