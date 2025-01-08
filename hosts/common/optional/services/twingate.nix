#FIXME Twingate daemon will keep failing when rebuilding.

{ pkgs, ... }:

{
  services.twingate = {
    enable = true;
    package = pkgs.twingate;
  };
  environment.systemPackages = [ pkgs.twingate ];
}
