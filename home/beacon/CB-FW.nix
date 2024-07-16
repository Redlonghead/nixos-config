{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/style/style.nix
    common/optional/wm/hyprland/hyprland.nix
    common/optional/kitty.nix
    common/optional/tmux.nix
    # common/optional/zsh.nix
    # common/optional/sops.nix
    # common/optional/helper-scripts

    # common/optional/desktops
  ];

  #FIXME
  # services.yubikey-touch-detector.enable = true;

  home = {
    username = configVars.userSettings.username;
    homeDirectory = "/home/${configVars.userSettings.username}";
  };
}