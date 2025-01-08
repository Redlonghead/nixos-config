{
  config,
  pkgs,
  configVars,
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      general = [
        {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = false;
          ignore_empty_input = true;
        }
      ];

      background = [
        {
          path = config.stylix.image;
          blur_passes = 2;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color =
            "rgb("
            + config.lib.stylix.colors.base07-rgb-r
            + ","
            + config.lib.stylix.colors.base07-rgb-g
            + ","
            + config.lib.stylix.colors.base07-rgb-b
            + ")";
          inner_color =
            "rgb("
            + config.lib.stylix.colors.base00-rgb-r
            + ","
            + config.lib.stylix.colors.base00-rgb-g
            + ","
            + config.lib.stylix.colors.base00-rgb-b
            + ")";
          font_color =
            "rgb("
            + config.lib.stylix.colors.base07-rgb-r
            + ","
            + config.lib.stylix.colors.base07-rgb-g
            + ","
            + config.lib.stylix.colors.base07-rgb-b
            + ")";
          fade_on_empty = true;
          fade_timeout = 5000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color =
            "rgb("
            + config.lib.stylix.colors.base0A-rgb-r
            + ","
            + config.lib.stylix.colors.base0A-rgb-g
            + ","
            + config.lib.stylix.colors.base0A-rgb-b
            + ")";
          fail_color =
            "rgb("
            + config.lib.stylix.colors.base08-rgb-r
            + ","
            + config.lib.stylix.colors.base08-rgb-g
            + ","
            + config.lib.stylix.colors.base08-rgb-b
            + ")";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
          fail_transition = 300; # transition time in ms between normal outer_color and fail_color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false; # change color if numlock is off
          swap_font_color = false; # see below

          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          # Show hello user text
          monitor = "";
          text = "Hello, $DESC";
          color =
            "rgb("
            + config.lib.stylix.colors.base07-rgb-r
            + ","
            + config.lib.stylix.colors.base07-rgb-g
            + ","
            + config.lib.stylix.colors.base07-rgb-b
            + ")";
          font_size = 25;
          font_family = configVars.userSettings.font;
          rotate = 0; # degrees, counter-clockwise

          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          # Show time
          monitor = "";
          text = "$TIME";
          color =
            "rgb("
            + config.lib.stylix.colors.base07-rgb-r
            + ","
            + config.lib.stylix.colors.base07-rgb-g
            + ","
            + config.lib.stylix.colors.base07-rgb-b
            + ")";
          font_size = 20;
          font_family = "Intel One Mono";
          rotate = 0; # degrees, counter-clockwise
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
