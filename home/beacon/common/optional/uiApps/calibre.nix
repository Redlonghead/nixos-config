{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [ pkgs.calibre ];

  # auto download DeDRM and ACSM Input plugins for Calibre
  home.file = {
    ".config/calibre/nixos-plugins/ACSM Input.zip".source =
      inputs.calibrePlugins.packages.x86_64-linux.acsm-calibre-plugin;
    ".config/calibre/nixos-plugins/DeDRM.zip".source =
      inputs.calibrePlugins.packages.x86_64-linux.dedrm-plugin;
  };
}
