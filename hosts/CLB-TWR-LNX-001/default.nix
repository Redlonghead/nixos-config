#############################################################
#
#  CLB-TWR-LNX-001 - Personal Desktop at home
#    with Windows Dual Booting
#  NixOS
#
#############################################################

{
  lib,
  ...
}:

{
  imports = [
    ############ Every Host Needs This ###############
    ./hardware-configuration.nix

    ############ Hardware Modules ####################

    ############ NixOS-Secrets Modules ###############

  ]
  ++ (map lib.custom.relativeToRoot [
    ############ Required Configs ####################
    "hosts/common/core"

    ############ Hardware Modules ####################
    "hosts/common/optional/hardware/gpu/nvidia.nix"

    ############ Host-specific optional Config #######
    "hosts/common/optional/services/bluetooth.nix"
    "hosts/common/optional/services/openssh.nix"
    "hosts/common/optional/services/pipewire.nix"
    "hosts/common/optional/services/printing.nix"
    "hosts/common/optional/brightnessctl.nix"
    "hosts/common/optional/wm/hyprland.nix"
    "hosts/common/optional/appimage.nix"
    "hosts/common/optional/steam.nix"

    ############ User to create ######################
    "hosts/common/users/beacon/CLB-TWR-LNX-001.nix"

  ]);

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 10; # Limits amount of configs on boot screen
      useOSProber = true;
    };
  };

  networking.hostName = "CLB-TWR-LNX-001";

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  # This is a fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true; # On for VScode server
}
