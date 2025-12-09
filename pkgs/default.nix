# You can build these directly using 'nix build .#example'

{
  pkgs ? import <nixpkgs> { },
}:

{

  #################### Packages with external source ####################

  cd-gitroot = pkgs.callPackage ./cd-gitroot { };
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };
  librepods = pkgs.callPackage ./librepods { };
  elegant-sddm-qt6 = pkgs.callPackage ./elegant-sddm-qt6 { };

}
