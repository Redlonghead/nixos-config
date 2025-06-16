{ pkgs, ... }:

{

  home.packages =
    (with pkgs; [

      # Everything
      # bitwarden
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
      yubioath-flutter
      keepassxc
      # modrinth-app
      prismlauncher
      calibre

      # Made by KDE
      kdePackages.dolphin
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
