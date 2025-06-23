{
  lib,
  ...
}:

{
  time.timeZone = lib.mkDefault "America/Chicago";
  services.timesyncd.enable = true;
}
