{ ... }:

{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### Host-specific Optional Configs ####################
    common/optional/wm/hyprland
    common/optional/uiApps
    common/optional/cli-apps.nix

  ];

  services.yubikey-touch-detector.enable = true;

}
