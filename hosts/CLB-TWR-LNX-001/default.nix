#############################################################
#
#  CLB-TWR-LNX-001 - Personal Desktop at home
#    with Windows Dual Booting
#  NixOS
#
#############################################################

{
  configLib,
  ...
}:

{
  imports =
    [
      ############ Every Host Needs This ###############
      ./hardware-configuration.nix

      ############ Hardware Modules ####################

      ############ NixOS-Secrets Modules ###############

    ]
    ++ (map configLib.relativeToRoot [
      ############ Required Configs ####################
      "hosts/common/core"

      ############ Host-specific optional Config #######
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/pipewire.nix"
      "hosts/common/optional/services/printing.nix"
      "hosts/common/optional/services/syncthing.nix"
      "hosts/common/optional/brightnessctl.nix"
      "hosts/common/optional/wm/hyprland.nix"
      "hosts/common/optional/appimage.nix"
      # "hosts/common/optional/steam.nix"
      "hosts/common/optional/style.nix"

      ############ User to create ######################
      "hosts/common/users/beacon"

    ]);

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    systemd-boot.configurationLimit = 10; # Limits amount of configs on boot screen
  };

  networking = {
    hostName = "CLB-TWR-LNX-001";
    # interfaces = {
    #   wlp41s0.ipv4.addresses = [{
    #     address = "10.1.1.32";
    #     prefixLength = 16;
    #   }];

    #   enp42s0.ipv4.addresses = [{
    #     address = "10.1.1.22";
    #     prefixLength = 16;
    #   }];
    # };
  };

  # This is a fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true; # On for VScode server
}
