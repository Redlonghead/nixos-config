{ pkgs, ... }:

{
  # Import wayland config
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  environment.systemPackages = with pkgs; [
    waybar
    networkmanagerapplet
    rofi-wayland
    mako
    libnotify
    polkit_gnome
    playerctl
  ];

  # Security
  security = {
    pam.services.hyprlock = {
      text = ''
        auth include login
      '';
    };
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland = {
      enable = true;
    };
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  # fixes opengl/mesa version mismatch
  hardware.graphics = {
    package = pkgs.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
    package32 = pkgs.pkgsi686Linux.mesa.drivers;
  };
}
