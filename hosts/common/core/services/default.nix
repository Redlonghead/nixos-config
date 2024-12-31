{ configVars, ... }:

{
  #FIXME Called default.nix for the configlib.scanPaths 

  time.timeZone = "America/Chicago";
  services.timesyncd.enable = true;
}
