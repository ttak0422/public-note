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
              tcardgen
            ];
            src = lib.cleanSource ./.;
            buildPhase = ''
              # theme
              mkdir -p themes
              ln -snf ${pkgs.typo} themes/typo
              # og image
              for x in content/posts/*/index.md content/articles/*/index.md; do
                [ -f "$x" ] || continue
                id=$(basename "$(dirname "$x")")
                tcardgen \
                  --fontDir tcardgen \
                  --config tcardgen/blog.yaml \
                  --output "static/og/$id.png" \
                  -t tcardgen/blog.png \
                  "$x"
              done
              # hugo
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
              nodejs_22
              pnpm
            ];
            shellHook = ''
              mkdir -p themes
              ln -snf ${pkgs.typo} themes/typo
            '';
          };
        };
    };
}
