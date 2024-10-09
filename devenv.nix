{ pkgs, ... }:
{
  packages = with pkgs; [
    git
    libei
    libxkbcommon
    openssl.dev
    pkg-config
    systemd.dev
    wayland
    xorg.libX11
    xorg.libXtst
    yq
  ];
  android = {
    enable = true;
    flutter.enable = true;
  };
  languages = {
    c.enable = true;
    cplusplus.enable = true;
    javascript.enable = true;
    nix.enable = true;
    rust.enable = true;
    shell.enable = true;
    swift.enable = true;
    typescript.enable = true;
  };
  devcontainer.enable = true;
  difftastic.enable = true;
  pre-commit = {
    settings.rust.cargoManifestPath = "./src/rust/Cargo.toml";
    hooks = {
      actionlint.enable = true;
      clippy = {
        enable = true;
        settings.offline = false;
      };
      #    markdownlint.enable = true;
      nixpkgs-fmt.enable = true;
      rustfmt = {
        enable = true;
      };
      #    shellcheck.enable = true;
      #    shfmt.enable = true;
      #    statix.enable = true;
    };
  };
}
