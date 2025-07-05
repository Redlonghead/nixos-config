{
  pkgs,
  ...
}:

{
  imports = [

    ./calibre.nix

  ];

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

      # Floorp crashing often; Issue created for it.
      # https://github.com/NixOS/nixpkgs/issues/418473
      floorp # browser

    ])
    ++ (with pkgs.unstable; [

      vscode # code editor
      # until vim is setup

    ]);

}
