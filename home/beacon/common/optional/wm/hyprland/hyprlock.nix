{
  config,
  pkgs,
  ...
}:

let
  sColor = config.lib.stylix.colors;
in
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
          path = [
            (builtins.toString config.stylix.image)
          ];
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
          outer_color = "rgb(${sColor.base07-rgb-r},${sColor.base07-rgb-g},${sColor.base07-rgb-b})";
          inner_color = "rgb(${sColor.base00-rgb-r},${sColor.base00-rgb-g},${sColor.base00-rgb-b})";
          font_color = "rgb(${sColor.base07-rgb-r},${sColor.base07-rgb-g},${sColor.base07-rgb-b})";
          fade_on_empty = true;
          fade_timeout = 5000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color = "rgb(${sColor.base0A-rgb-r},${sColor.base0A-rgb-g},${sColor.base0A-rgb-b})";
          fail_color = "rgb(${sColor.base08-rgb-r},${sColor.base08-rgb-g},${sColor.base08-rgb-b})";
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
          color = "rgb(${sColor.base07-rgb-r},${sColor.base07-rgb-g},${sColor.base07-rgb-b})";
          font_size = 25;
          font_family = "Intel One Mono";
          rotate = 0; # degrees, counter-clockwise

          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          # Show time
          monitor = "";
          text = "$TIME12";
          color = "rgb(${sColor.base07-rgb-r},${sColor.base07-rgb-g},${sColor.base07-rgb-b})";
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
