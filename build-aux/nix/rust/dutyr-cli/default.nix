{ lib
, rustPlatform
, pkg-config
, systemd
, libxkbcommon
, wayland
, openssl
, xorg
, libei
}:
let
  pname = "dutyr-cli";
  version = "unstable";

  src = lib.cleanSource ../../../../src/rust/.;
in
rustPlatform.buildRustPackage {
  inherit version src pname;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config ];
  buildAndTestSubdir = "./crates/bin/dutyr-cli";

  buildInputs = [
    libei
    libxkbcommon
    systemd.dev
    wayland
    openssl.dev
    xorg.libX11
    xorg.libXtst
  ];

  postFixup = ''
    patchelf $out/bin/dutyr-cli \
      --add-rpath ${lib.makeLibraryPath [ libxkbcommon wayland xorg.libX11 xorg.libXtst libei ]}
  '';

  meta = with lib; {
    description = "";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ shymega ];
    mainProgram = "dutyr-cli";
  };
}
