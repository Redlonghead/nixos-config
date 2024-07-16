# You can build these directly using 'nix build .#example'

{ pkgs ? import <nixpkgs> { } }: rec {

  #################### Packages with external source ####################

  cd-gitroot = pkgs.callPackage ./cd-gitroot { };
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };

}
