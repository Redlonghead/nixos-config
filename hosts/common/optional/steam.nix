{ pkgs, ... }:

{
  hardware.graphics.enable32Bit = true;
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
  environment.systemPackages = with pkgs; [
    steam
    mangohud 
  ];



}
