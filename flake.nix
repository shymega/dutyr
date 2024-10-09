{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    nixpkgs-devenv.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs-devenv";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        with pkgs;
        rec {
          dutyr-cli = callPackage ./build-aux/nix/rust/dutyr-cli { };
          dutyr-daemon = callPackage ./build-aux/nix/rust/dutyr-daemon { };
          dutyr-server = callPackage ./build-aux/nix/rust/dutyr-server { };
          dutyr-app = callPackage ./build-aux/nix/flutter/app { };
          default = all;
          all = pkgs.symlinkJoin {
            name = "all";
            paths = [
              dutyr-app
              dutyr-cli
              dutyr-daemon
              dutyr-server
            ];
          };
          devenv-up = self.devShells.${system}.default.config.procfileScript;
        });

      devShells = forEachSystem
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                ./devenv.nix
              ];
            };
          });
    } // {
      overlays.default = final: _: {
        inherit (self.packages.${final.system}) dutyr-cli dutyr-daemon dutyr-app dutyr-server;
      };
    };
}
