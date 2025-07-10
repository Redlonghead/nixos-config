{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [

    # Everything
    libqalculate
    openldap
    protonmail-bridge
    yubikey-manager
    gh
    glab
    glow
    nixpkgs-review

    # Remember
    # terraform

    # Since I am a maintainer I trust the unstable pkg
    unstable.pakku

  ];
}
