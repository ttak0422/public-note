{ inputs }:
final: _:
let
  inherit (final) stdenv;
in
{
  typo = stdenv.mkDerivation rec {
    pname = "typo";
    version = src.rev;
    src = inputs.typo-src;
    dontBuild = false;
    installPhase = ''
      mkdir $out
      cp -r ./* $out
    '';
  };
}
