{
  lib,
  pkgs,
  outputs,
  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ (builtins.attrValues outputs.homeModules);

  # Default Info / Settings
  news.display = "silent";
  home = {
    username = "beacon";
    homeDirectory = lib.mkDefault "/home/beacon";
    stateVersion = lib.mkDefault "23.11"; # Don't change.
    sessionVariables = {
      SHELL = "zsh";
      EDITOR = "nano";
    };
  };

  home.packages = (
    with pkgs;
    [
      nix-output-monitor
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

  stylix.targets = {
    bat.enable = true;
    yazi.enable = true;
  };

  programs = {
    home-manager.enable = true;

    bat = {
      enable = true;
      package = pkgs.bat;
    };

    eza = {
      enable = true;
      package = pkgs.eza;
      enableZshIntegration = true;
      git = true;
      icons = "always";
      colors = "auto";
    };

    nh = {
      enable = true;
      flake = "$HOME/src/nixos-config";
      package = pkgs.nh;
      clean.enable = true;
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

  services = {
    ssh-agent.enable = true;

    udiskie.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
