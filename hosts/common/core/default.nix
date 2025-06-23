{
  outputs,
  configLib,
  pkgs,
  lib,
  ...
}:

{
  imports = (configLib.scanPaths ./.) ++ (builtins.attrValues outputs.nixosModules);

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    # Defaults env_keep + =SSH_AUTH_SOCK
  '';

  nixpkgs = {
    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  # Networking
  networking = {
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    enableIPv6 = false;
  };

  services = {
    yubikey-agent.enable = true;

    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      dnsovertls = "true";
    };
  };

  programs = {
    htop = {
      enable = true;
      package = pkgs.htop;
    };

    nh = {
      enable = true;
      flake = lib.mkDefault "/etc/nixos-config";
      package = pkgs.nh;
      clean.enable = true;
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };

  environment.systemPackages = with pkgs; [
    just
  ];

  hardware.enableRedistributableFirmware = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
