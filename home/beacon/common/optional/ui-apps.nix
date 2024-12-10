{ pkgs, ... }:

{

  home.packages = (with pkgs; [

    vlc
    youtube-music
    obs-studio
    remmina
    bitwarden

    dolphin
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras

    libreoffice-qt
    hunspell # LibraOffice Spellcheck
    hunspellDicts.en_US

    moonlight-qt
    thunderbird
    protonmail-bridge-gui
    obsidian
    discord
    terraform
    qalculate-qt
    olive-editor
    yubikey-manager-qt
    putty
    kicad

  ]) ++
  (with pkgs.unstable; [

    floorp
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
