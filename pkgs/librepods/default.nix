{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  udev,
  dbus,
  libpulseaudio,
  qt6,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "librepods";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "a01e16792a73deb34c5bd0c4aa019c496642ee71";
    hash = "sha256-ZvHbSSW0rfcsNUORZURe0oBHQbnqmS5XT9ffVMwjIMU=";
  };

  sourceRoot = "source/linux-rust";
  cargoHash = "sha256-Ebqx+UU2tdygvqvDGjBSxbkmPnkR47/yL3sCVWo54CU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpulseaudio
    dbus
  ];

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
})

# stdenv.mkDerivation (finalAttrs: {
#   pname = "librepods";
#   version = "0.1.0";

#   src = fetchFromGitHub {
#     owner = "kavishdevar";
#     repo = "librepods";
#     tag = "linux-v${finalAttrs.version}";
#     hash = "sha256-ZvHbSSW0rfcsNUORZURe0oBHQbnqmS5XT9ffVMwjIMU=";
#   };

#   buildInputs = [
#     qt6.qtbase
#     qt6.qtmultimedia
#     qt6.qtconnectivity
#   ];

#   nativeBuildInputs = [
#     qt6.wrapQtAppsHook
#     cmake
#     pkg-config
#     libpulseaudio
#   ];

#   configurePhase = ''
#     runHook preConfigure

#     cmake linux/CMakeLists.txt

#     runHook postConfigure
#   '';

#   installPhase = ''
#     runHook preInstall

#     mkdir -p $out/bin $out/applications
#     cp librepods $out/bin
#     cp linux/assets/me.kavishdevar.librepods.desktop $out/applications/

#     runHook postInstall
#   '';

#   postInstall = ''
#     wrapProgram $out/bin/librepods \
#       --unset QT_STYLE_OVERRIDE
#   '';

#   meta = {
#     description = "AirPods liberated from Apple's ecosystem.";
#     longDescription = ''
#       LibrePods unlocks Apple's exclusive AirPods features on non-Apple devices. Get access to noise control modes, adaptive transparency, ear detection, hearing aid, customized transparency mode, battery status, and more - all the premium features you paid for but Apple locked to their ecosystem.
#     '';
#     homepage = "https://github.com/kavishdevar/librepods/tree/main";
#     downloadPage = "https://github.com/kavishdevar/librepods/releases/tag/${finalAttrs.src.tag}";
#     mainProgram = "librepods";
#     license = lib.licenses.gpl3;
#     # platforms = ;
#     maintainers = with lib.maintainers; [ redlonghead ];
#   };

# })
