{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # Everything
    libqalculate
    openldap
    protonmail-bridge
    yubikey-manager

    # Remember
    # terraform

  ];
}
