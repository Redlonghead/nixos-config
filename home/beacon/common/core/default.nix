{ config, lib, pkgs, outputs, configLib, ... }:
{
  imports = (configLib.scanPaths ./.)
    ++ (builtins.attrValues outputs.homeManagerModules);
  services.ssh-agent.enable = true;

  # Default Info / Settings
  news.display = "silent";
  home = {
    username = "beacon";
    homeDirectory = lib.mkDefault "/home/beacon";
    stateVersion = lib.mkDefault "23.11"; # Don't change.
    sessionVariables = {
      FLAKE = "$HOME/nix-config";
      SHELL = "zsh";
      EDITOR = "nano";
    };
  };

  home.packages = (with pkgs; [

    localsend
    sops
    ranger
    bitwarden-cli
    just
    fastfetch
    zip
    unzip

    #TODO NIX Neovim
    vim
    neovim

  ]); # ++
  # (with pkgs.unstable; [ STUFF ])

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
