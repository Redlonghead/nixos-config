{ configVars, inputs, lib, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      UseDns = true;
      PermitRootLogin = "no";
    };

    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
    # Fix LPE vulnerability with sudo use SSH_AUTH_SOCK: https://github.com/NixOS/nixpkgs/issues/31611
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
  };

  security.pam = {
    sshAgentAuth.enable = true;
    services = {
      sudo.u2fAuth = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
