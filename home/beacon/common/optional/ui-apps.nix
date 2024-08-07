{ pkgs, ... }:

{

  home.packages = (with pkgs; [

    firefox
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
    home-manager.enable = true;
    direnv.enable = true;
    zsh = {
      shellAliases = {
        tg = "twingate";
        tgs = "twingate status";
        tgr = "twingate resources";
      };
    };
  };

}
