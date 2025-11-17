{
  description = "note";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    typo-src = {
      url = "github:tomfran/typo";
      flake = false;
    };
    tcardgen-src = {
      url = "github:Ladicle/tcardgen";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          system,
          pkgs,
          lib,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (import ./nix/overlays.nix { inherit inputs; })
            ];
          };
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "note";
            version = "0.0.1";
            buildInputs = with pkgs; [
              hugo
              typo
            ];
            src = lib.cleanSource ./.;
            buildPhase = ''
              mkdir -p themes
              ln -snf ${pkgs.typo} themes/typo
              hugo build
            '';
            installPhase = ''
              cp -r public $out
            '';
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              hugo
              tcardgen
            ];
            shellHook = ''
              mkdir -p themes
              ln -snf ${pkgs.typo} themes/typo
            '';
          };
        };
    };
}
