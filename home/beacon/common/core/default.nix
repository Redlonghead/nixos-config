{
  config,
  lib,
  pkgs,
  outputs,
  configLib,
  configVars,
  ...
}:
{
  imports = (configLib.scanPaths ./.) ++ (builtins.attrValues outputs.homeModules);
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

  home.packages = (
    with pkgs;
    [
      localsend
      sops
      nixd
      nixfmt-rfc-style
      bitwarden-cli
      just
      fastfetch
      zip
      unzip

      #TODO NIX Neovim
      vim
      neovim

    ]
  ); # ++
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

    bat = {
      enable = true;
      package = pkgs.bat;
      config.theme = "Visual Studio Dark+";
    };

    eza = {
      enable = true;
      package = pkgs.eza;
      enableZshIntegration = true;
      git = true;
      icons = "always";
      colors = "auto";
    };

    yazi = {
      enable = true;
      package = pkgs.yazi;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      package = pkgs.zoxide;
      enableZshIntegration = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
