{ config, pkgs, ... }:

{

  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./waybar.nix
    ../../style
    ../cursor.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    settings = {
      "monitor" = [
        # Work Monitors
        "desc:HP Inc. HP E24 G4 CN42173KHX,preferred,1920x0,auto"
        "desc:HP Inc. HP E24 G4 CN42173KJK,preferred,0x0,auto"

        # Home Monitors
        "desc:Samsung Electric Company SAMSUNG 0x01000E00,preferred,0x0,auto"
        "desc:Samsung Electric Company LF27T35 HCNTC02221,preferred,1920x0,auto"

        # Laptop screen
        "desc:BOE 0x0BCA,preferred,3840x0,1.175"

        # Default
        ",preferred,auto,auto"
      ];

      exec-once = [
        "waybar"
        "hypridle"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "bash ~/.config/hypr/start.sh"
        "bash ~/.swaybg-stylix"
        "blueman-applet"
        "xwaylandvideobridge"
      ];

      "$mainMod" = "SUPER";

      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, Z, togglefloating,"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Custom Stuff
        "$mainMod, V, exec, code"
        "$mainMod, O, exec, obsidian"
        "$mainMod, N, exec, code /home/beacon/Documents/NixOS.code-workspace"
        "$mainMod, F, exec, floorp"
        "$mainMod, E, exec, rofi -show combi -show-icons -combi-modes 'drun,run'"
        ", code:234, exec, rofi -show combi -show-icons -combi-modes 'drun,run'"
        "$mainMod, L, exec, hyprlock"

        # Media
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      "binde" = [
        # e = repeat if held

        # Audio
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      "bindle" = [
        # le = when locked / repeat if held 

        # Brightness; 
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5%"

        # Volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      "bindm" = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Hide xwaylandvideobridge when ran
      "windowrulev2" = [
        "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];

      # Default Config stuff

      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      input = [{
        "kb_layout" = "us";
      }];

      general = [{
        "gaps_in" = 5;
        "gaps_out" = 20;
        "border_size" = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        "layout" = "dwindle";
        "allow_tearing" = false;
      }];

      decoration = [{
        "rounding" = 10;
        blur = {
          "enabled" = true;
          "size" = 3;
          "passes" = 1;
        };
      }];

      animations = [{
        "enabled" = "yes";
        "bezier" = "myBezier, 0.05, 0.9, 0.1, 1.05";
        "animation" = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      }];

      dwindle = [{
        "pseudotile" = "yes";
        "preserve_split" = "yes";
      }];

      # master = [{
      #   "new_is_master" = true;
      # }];

      gestures = [{
        "workspace_swipe" = "off";
      }];

      misc = [{
        "force_default_wallpaper" = 0;
      }];

    };
  };

}
