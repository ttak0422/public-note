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
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (import ./nix/overlays.nix { inherit inputs; })
            ];
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              hugo
            ];
            shellHook = ''
              mkdir -p themes
              ln -snf ${pkgs.typo} themes/typo
            '';
          };
        };
    };
}
