{
  config,
  ...
}:

{
  sops.secrets."users/beacon/ssh" = {
    owner = "beacon";
    inherit (config.users.users.beacon) group;
    path = "/home/beacon/.ssh/id_beacon";
  };
}
