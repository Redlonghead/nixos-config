{ config, inputs, configVars, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {

    # String to SOPS when added as input to flake.
    defaultSopsFile = "${builtins.toString inputs.nix-secrets}/host-secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # keyFile = "/var/lib/sops-nix/key.txt";
      # generateKey = true;
    };

    secrets = {
      # add secrets to be extracted under /run with root priv by default
      "users/${configVars.userSettings.username}/ssh" = {
        owner = config.users.users.${configVars.userSettings.username}.name;
        inherit (config.users.users.${configVars.userSettings.username}) group;

        path = "/home/${configVars.userSettings.username}/.ssh/id_${configVars.userSettings.username}";
      };

    };

  };
}
