{ config, lib, pkgs, outputs, configLib, configVars, ... }:
{
  imports = (configLib.scanPaths ./.)
    ++ (builtins.attrValues outputs.homeManagerModules);
  services.ssh-agent.enable = true;

  # Default Info / Settings
  news.display = "silent";
  home = {
    username = lib.mkDefault configVars.userSettings.username;
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
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
    protonmail-bridge
    fastfetch

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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
