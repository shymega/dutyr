{ lib
, flutter322
, glibc
, libclang
, clang
, gcc
, git
, rustup
, targetFlutterPlatform ? "web"
}:
flutter322.buildFlutterApplication rec {
  pname = "dutyr-app-${targetFlutterPlatform}";
  version = "unstable";

  # To build for the Web, use the targetFlutterPlatform argument.
  inherit targetFlutterPlatform;

  src = lib.cleanSource ../../../../src/flutter/.;

  buildInputs = [ glibc libclang clang gcc git rustup ];

  pubspecLock = lib.importJSON "${src}/pubspec.lock.json";
}
