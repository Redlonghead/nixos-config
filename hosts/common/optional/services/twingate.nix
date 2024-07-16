{ pkgs, ... }:

{
  services.twingate = {
    enable = true;
    package = pkgs.twingate;
  };
  environment.systemPackages = [ pkgs.twingate ];
}
