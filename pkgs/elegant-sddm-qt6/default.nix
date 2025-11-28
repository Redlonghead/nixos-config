{
  lib,
  formats,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  /*
    An example of how you can override the background with a NixOS wallpaper
    *
    *  environment.systemPackages = [
    *    (pkgs.elegant-sddm.override {
    *      themeConfig.General = {
             background = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath}";
    *      };
    *    })
    *  ];
  */
  themeConfig ? null,
}:

let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
in

stdenvNoCC.mkDerivation {
  pname = "elegant-sddm";
  version = "unstable-2024-03-30";

  src = fetchFromGitHub {
    owner = "rainD4X";
    repo = "Elegant-sddm-qt6";
    rev = "66952cbe32460938c0b6e8c6cf3343047af098f0";
    hash = "sha256-l4gv1PEVWpLmzNt1c+dHTHtM5WlEsXdDgW3q8U3FMUQ=";
  };

  propagatedBuildInputs = [
    kdePackages.qt5compat
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes"
    cp -r Elegant/ "$out/share/sddm/themes/Elegant"
  ''
  + (lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/Elegant/theme.conf.user
  '')
  + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sleek and stylish SDDM theme crafted in QML for Qt6";
    homepage = "https://github.com/rainD4X/Elegant-sddm-qt6";
    license = licenses.gpl3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
