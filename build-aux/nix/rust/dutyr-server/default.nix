{ lib
, rustPlatform
, pkg-config
, openssl
}:
let
  pname = "dutyr-server";
  version = "unstable";

  src = lib.cleanSource ../../../../src/rust/.;
in
rustPlatform.buildRustPackage {
  inherit version src pname;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config ];
  buildAndTestSubdir = "./crates/bin/dutyr-server";

  buildInputs = [
    openssl.dev
  ];

  meta = with lib; {
    description = "";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ shymega ];
    mainProgram = "dutyr-server";
  };
}
