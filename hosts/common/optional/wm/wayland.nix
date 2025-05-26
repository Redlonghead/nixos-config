{ config, pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    wayland
    waydroid
    (sddm-chili-theme.override {
      themeConfig = {
        background = config.stylix.image;
        ScreenWidth = 1920;
        ScreenHeight = 1080;
        blur = true;
        recursiveBlurLoops = 3;
        recursiveBlurRadius = 5;
      };
    })
  ];

  # Configure xwayland
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.sddm = {
      enable = true;
      # wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
      package = pkgs.kdePackages.sddm;
    };
  };

  # Define systemd service to run on boot to load avatars for sddm
  systemd.services."sddm-avatar" = {
    description = "Service to copy or update users Avatars at startup.";
    wantedBy = [ "multi-user.target" ];
    before = [ "sddm.service" ];
    script = ''
      set -eu
      for user in /home/*; do
          username=$(basename "$user")
          if [ -f "$user/.face.icon" ]; then
              if [ ! -f "/var/lib/AccountsService/icons/$username" ]; then
                  cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
              else
                  if [ "$user/.face.icon" -nt "/var/lib/AccountsService/icons/$username" ]; then
                      cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
                  fi
              fi
          fi
      done
    '';
    serviceConfig = {
      Type = "simple";
      User = "root";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };

  # Ensures SDDM starts after the service.
  systemd.services.sddm = {
    after = [ "sddm-avatar.service" ];
  };
}
