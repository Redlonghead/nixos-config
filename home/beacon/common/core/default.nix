{ config, lib, pkgs, pkgs-stable, outputs, configLib, configVars, ... }:
{
  imports = (configLib.scanPaths ./.);
  #FIXME error: infinite recursion encountered
  # ++ (builtins.attrValues outputs.homeManagerModules);
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
      TERM = "kitty";
      TERMINAL = "kitty";
      EDITOR = "nano";
    };
  };

  home.packages = (with pkgs; [

    firefox
    localsend
    vlc
    youtube-music
    obs-studio
    sops
    ranger
    remmina

    # Unfree
    obsidian
    discord
    spotify
    vscode
    terraform

  ]) ++
  (with pkgs-stable; [

    # Password Manager so it should always work
    bitwarden
    bitwarden-cli

  ]);

  services.mpris-proxy.enable = true;

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
    zsh = {
      shellAliases = {
        tg = "twingate";
        tgs = "twingate status";
        tgr = "twingate resources";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
