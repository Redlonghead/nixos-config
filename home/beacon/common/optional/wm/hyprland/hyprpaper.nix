{
  pkgs,
  config,
  ...
}:

{
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      preload = [
        (builtins.toString config.stylix.image)
      ];

      wallpaper = [
        ",${builtins.toString config.stylix.image}"
      ];
    };
  };
}
