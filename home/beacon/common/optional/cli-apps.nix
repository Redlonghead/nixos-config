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
    pakku

    # Remember
    # terraform

  ];
}
