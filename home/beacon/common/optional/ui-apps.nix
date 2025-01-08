{ pkgs, ... }:

{

  home.packages =
    (with pkgs; [

      # Everything
      bitwarden
      discord
      moonlight-qt
      obsidian
      obs-studio
      protonmail-bridge-gui
      qalculate-qt
      remmina
      thunderbird
      vlc
      youtube-music
      yubikey-manager-qt

      # Made by KDE
      dolphin
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.qtwayland
      kdePackages.qtsvg

      # Libre Office
      hunspell # Spellcheck
      hunspellDicts.en_US
      libreoffice-qt

      # Remember these apps
      # kicad
      # olive-editor

    ])
    ++ (with pkgs.unstable; [

      floorp # browser
      vscode # code editor
      # until vim is setup

    ]);

}
