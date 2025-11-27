{
  pkgs,
  ...
}:

{

  wayland.windowManager.hyprland.settings.exec-once = [ "hypridle" ];

  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      general = [
        {
          lock_cmd = "pgrep hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
        }
      ];

      listener = [
        {
          # Lock after 5 min.
          timeout = 300; # in seconds
          on-timeout = "loginctl lock-session";
        }
        {
          # FIXME Hyprland crashes when waking up on NVIDIA GPU
          # base the fix on https://github.com/0xFMD/hyprland-suspend-fix which might work
          # Suspend after 7 min.
          timeout = 420; # in seconds
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
