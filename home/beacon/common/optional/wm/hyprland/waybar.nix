{
  config,
  pkgs,
  configVars,
  ...
}:

let
  sColor = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [
    networkmanagerapplet
    lxqt.pavucontrol-qt
  ];

  services.udiskie.enable = true;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 35;
      margin = "7 7 3 7";
      spacing = 2;

      modules-left = [
        "custom/os"
        "custom/hyprprofile"
        "battery"
        "backlight"
        "keyboard-state"
        "pulseaudio"
        "cpu"
        "memory"
      ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [
        "idle_inhibitor"
        "tray"
        "clock"
      ];

      "custom/os" = {
        "format" = " {} ";
        "exec" = ''echo "" '';
        "interval" = "once";
        "on-click" = "rofi -show combi -show-icons -combi-modes 'drun,run'";
      };
      "keyboard-state" = {
        "numlock" = true;
        "format" = " {icon} ";
        "format-icons" = {
          "locked" = "󰎠";
          "unlocked" = "󱧓";
        };
      };
      "hyprland/workspaces" = {
        "format" = "{icon}";
        "format-icons" = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "scratch_term" = "_";
          "scratch_yazi" = "_󰴉";
        };
        "on-click" = "activate";
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
        #"all-outputs" = true;
        "ignore-workspaces" = [
          "scratch"
          "-"
        ];
        #"show-special" = false;
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "󰅶";
          deactivated = "󰾪";
        };
      };
      tray = {
        #"icon-size" = 21;
        "spacing" = 10;
      };
      clock = {
        "interval" = 1;
        "format" = "{:%a %m-%d-%y %I:%M:%S %p}";
        "timezone" = configVars.userSettings.timeZone;
        "tooltip-format" = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
      };
      cpu = {
        "format" = "{usage}% ";
      };
      memory = {
        "format" = "{}% ";
      };
      backlight = {
        "format" = "{percent}% {icon}";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
      battery = {
        "states" = {
          "good" = 95;
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{capacity}% {icon}";
        "format-charging" = "{capacity}% ";
        "format-plugged" = "{capacity}% ";
        #"format-good" = ""; # An empty format will hide the module
        #"format-full" = "";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      pulseaudio = {
        "scroll-step" = 1;
        "format" = "{volume}% {icon}  {format_source}";
        "format-bluetooth" = "{volume}% {icon}  {format_source}";
        "format-bluetooth-muted" = "󰸈 {icon}  {format_source}";
        "format-muted" = "󰸈 {format_source}";
        "format-source" = "{volume}% ";
        "format-source-muted" = " ";
        "format-icons" = {
          "headphone" = "";
          "hands-free" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [
            ""
            ""
            ""
          ];
        };
        "on-click" = "pavucontrol-qt";
      };
    };
    style = ''
      * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: FontAwesome, Fira Code;
        font-size: 20px;
      }

      window#waybar {
        background-color: rgba(${sColor.base00-rgb-r},${sColor.base00-rgb-g},${sColor.base00-rgb-b},0.55);
        border-radius: 8px;
        color: #${sColor.base07};
        transition-property: background-color;
        transition-duration: .2s;
      }

      tooltip {
        color: #${sColor.base07};
        background-color: rgba(${sColor.base00-rgb-r},${sColor.base00-rgb-g},${sColor.base00-rgb-b},0.9);
        border-style: solid;
        border-width: 3px;
        border-radius: 8px;
        border-color: #${sColor.base08};
      }

      tooltip * {
        color: #${sColor.base07};
        background-color: rgba(${sColor.base00-rgb-r},${sColor.base00-rgb-g},${sColor.base00-rgb-b},0.0);
      }

      window > box {
          border-radius: 8px;
          opacity: 0.94;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
          border: none;
      }

      #custom-hyprprofile {
          color: #${sColor.base0D};
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
      }

      #workspaces button {
          padding: 0 7px;
          background-color: transparent;
          color: #${sColor.base04};
      }

      #workspaces button:hover {
          color: #${sColor.base07};
      }

      #workspaces button.active {
          color: #${sColor.base08};
      }

      #workspaces button.focused {
          color: #${sColor.base0A};
      }

      #workspaces button.visible {
          color: #${sColor.base05};
      }

      #workspaces button.urgent {
          color: #${sColor.base09};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
          padding: 0 10px;
          color: #${sColor.base07};
          border: none;
          border-radius: 8px;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #clock {
          color: #${sColor.base0D};
      }

      #battery {
          color: #${sColor.base0B};
      }

      #battery.charging, #battery.plugged {
          color: #${sColor.base0C};
      }

      @keyframes blink {
          to {
              background-color: #${sColor.base07};
              color: #${sColor.base00};
          }
      }

      #battery.critical:not(.charging) {
          background-color: #${sColor.base08};
          color: #${sColor.base07};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #${sColor.base00};
      }

      #cpu {
          color: #${sColor.base0D};
      }

      #memory {
          color: #${sColor.base0E};
      }

      #disk {
          color: #${sColor.base0F};
      }

      #backlight {
          color: #${sColor.base0A};
      }

      label.numlock {
          color: #${sColor.base04};
      }

      label.numlock.locked {
          color: #${sColor.base0F};
      }

      #pulseaudio {
          color: #${sColor.base0C};
      }

      #pulseaudio.muted {
          color: #${sColor.base04};
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
      }

      #idle_inhibitor {
          color: #${sColor.base04};
      }

      #idle_inhibitor.activated {
          color: #${sColor.base0F};
      }
    '';
  };
}
