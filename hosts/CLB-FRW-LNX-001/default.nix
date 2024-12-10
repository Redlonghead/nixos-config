#############################################################
#
#  CLB-FRW-LNX-001 - Personal Framework 13 laptop
#  NixOS
#
#############################################################

{ lib, inputs, configLib, pkgs, ... }:

{
  imports = [
    ############ Every Host Needs This ###############
    ./hardware-configuration.nix

    ############ Hardware Modules ####################
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel

    ############ NixOS-Secrets Modules ###############
    inputs.nixos-secrets.nixosModules.Tailscale-CT-CLB-FRW-LNX-001
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

    ############ User to create ######################
    "hosts/common/users/beacon"

  ]);

  networking.hostName = "CLB-FRW-LNX-001";

  # This is a fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true; # On for VScode server

  services = {
    tailscale.package = pkgs.unstable.tailscale;

    # FRAMEWORK Hardware Stuff
    fwupd.enable = true;

    # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
    # fwupd.package = (import (builtins.fetchTarball {
    #   url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
    #   sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
    # }) {
    #   inherit (pkgs) system;
    # }).fwupd;

    fprintd.enable = lib.mkForce false;

  };
}
