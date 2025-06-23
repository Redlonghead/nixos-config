{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [ pkgs.calibre ];

  # auto add DeDRM and ACSM Input plugins for Calibre
  home.file = {
    ".config/calibre/plugins/ACSM Input.zip".source =
      inputs.calibrePlugins.packages.x86_64-linux.acsm-calibre-plugin;
    ".config/calibre/plugins/DeDRM.zip".source =
      inputs.calibrePlugins.packages.x86_64-linux.dedrm-plugin;
  };
}
