{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {

    # String to SOPS when added as input to flake.
    defaultSopsFile = "${builtins.toString inputs.nixos-secrets}/sops/home-secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/home/beacon/.ssh/id_beacon" ];
    };

    secrets = {
      # add secrets to be extracted under $XDG_RUNTIME_DIR/secrets.d and symlink to $HOME/.config/sops-nix/secrets
      "wireguard/CB-FW" = { };

    };

  };
}
