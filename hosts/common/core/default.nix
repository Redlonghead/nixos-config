{ inputs, outputs, configLib, ... }: {
  imports = (configLib.scanPaths ./.)
    ++ (builtins.attrValues outputs.nixosModules);

  services.yubikey-agent.enable = true;

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
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  # environment.systemPackages = with pkgs; [
  # 
  # ];

  hardware.enableRedistributableFirmware = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
