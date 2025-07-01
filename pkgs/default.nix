# You can build these directly using 'nix build .#example'

{
  pkgs ? import <nixpkgs> { },
}:

{

  #################### Packages with external source ####################

  cd-gitroot = pkgs.callPackage ./cd-gitroot { };
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };

  # PR opened at Nixos/nixpkgs#421153
  # https://github.com/NixOS/nixpkgs/pull/421153
  # TODO remove once on master/25.05
  pakku = pkgs.callPackage ./pakku { };

}
