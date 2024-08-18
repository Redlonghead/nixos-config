#############################################################
#
#  CLB-FRW-LNX - Personal Framework 13 laptop
#  NixOS
#
#############################################################

{ lib, inputs, configLib, ... }:

{
  imports = [
    ############ Every Host Needs This ###############
    ./hardware-configuration.nix

    ############ Hardware Modules ####################
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel

    ############ NixOS-Secrets Modules ###############
    inputs.nixos-secrets.nixosModules.wireguard-CT-CLB-FRW-LNX
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
    "hosts/common/optional/services/twingate.nix"
    "hosts/common/optional/brightnessctl.nix"
    "hosts/common/optional/wm/hyprland.nix"
    "hosts/common/optional/lt-power.nix"
    "hosts/common/optional/appimage.nix"
    "hosts/common/optional/steam.nix"
    "hosts/common/optional/style.nix"

    ############ User to create ######################
    "hosts/common/users/beacon"

  ]);

  networking.hostName = "CLB-FRW-LNX";
  # networking.interfaces = {
  #   wlp170s0.ipv4.addresses = [{
  #     address = "10.1.1.21";
  #     prefix = 16;
  #   }];

  #   enp0s13f0u3.ipv4.addresses = [{
  #     address = "10.1.1.11";
  #     prefix = 16;
  #   }];
  # };

  # This is a fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true; # On for VScode server

  # FRAMEWORK Hardware Stuff
  services.fwupd.enable = true;

  # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
  # services.fwupd.package = (import (builtins.fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
  #   sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
  # }) {
  #   inherit (pkgs) system;
  # }).fwupd;

  services.fprintd.enable = lib.mkForce false;
}
