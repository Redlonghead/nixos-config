{
  inputs,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {

    # String to SOPS when added as input to flake.
    defaultSopsFile = "${builtins.toString inputs.nixos-secrets}/sops/host-secrets.yaml";
    validateSopsFiles = false;

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      # add secrets to be extracted under /run with root priv by default

    };

  };
}
