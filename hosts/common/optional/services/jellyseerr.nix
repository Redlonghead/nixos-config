{ pkgs, ... }:

{
  services.jellyseerr = {
    enable = true;
    port = 5055;
    openFirewall = true;
    package = pkgs.jellyseerr;
  };
}
