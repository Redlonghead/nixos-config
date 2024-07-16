{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/style/style.nix
    common/optional/wm/hyprland/hyprland.nix
    common/optional/kitty.nix
    common/optional/ui-apps.nix

  ];

  #FIXME
  services.yubikey-touch-detector.enable = true;

}
