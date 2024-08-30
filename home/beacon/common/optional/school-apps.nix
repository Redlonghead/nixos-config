{ pkgs, ... }:

{
  home.packages = (with pkgs; [
    ciscoPacketTracer8
    p3x-onenote
    teams-for-linux
    calibre
  ]);
}