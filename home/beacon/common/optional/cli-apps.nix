{ pkgs, ... }:

{
  home.packages = with pkgs; [

    protonmail-bridge
    libqalculate
    openldap
    yubikey-manager

  ];
}
