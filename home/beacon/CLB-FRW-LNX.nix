{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/style
    common/optional/wm/hyprland
    common/optional/kitty.nix
    common/optional/ui-apps.nix
    common/optional/school-apps.nix

  ];

  services.yubikey-touch-detector.enable = true;

}
