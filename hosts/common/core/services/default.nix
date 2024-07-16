{ configVars, ... }:

{
  #FIXME Called default.nix for the configlib.scanPaths 

  time.timeZone = configVars.systemSettings.timezone;
  services.timesyncd.enable = true;
}
