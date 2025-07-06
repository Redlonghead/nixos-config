{
  pkgs,
  ...
}:

{
  # Import wayland config
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
    ../style.nix
  ];

  # Security
  security = {
    pam.services.hyprlock = {
      text = ''
        auth include login
      '';
    };
  };

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland = {
      enable = true;
    };
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
}
