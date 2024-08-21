{ pkgs, ... }:

{

  home.packages = (with pkgs; [

    floorp
    vlc
    youtube-music
    obs-studio
    remmina
    bitwarden
    dolphin
    libreoffice-qt
    hunspell # LibraOffice Spellcheck
    hunspellDicts.en_US
    moonlight-qt
    thunderbird
    protonmail-bridge-gui

    # Unfree
    obsidian
    discord
    spotify
    terraform

  ]) ++
  (with pkgs.unstable; [ 
  
    vscode 
  
  ]);

  services.mpris-proxy.enable = true;

  programs = {
    zsh = {
      shellAliases = {
        tg = "twingate";
        tgs = "twingate status";
        tgr = "twingate resources";
      };
    };
  };

}
