{ ... }:

{
  sops.secrets."users/beacon/ssh" = {
    owner = "beacon";
    group = "beacon";
    path = "/home/beacon/.ssh/id_beacon";
  };
}
