{ inputs }:
final: _:
let
  inherit (final) stdenv buildGo125Module;
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
    tcardgen = buildGo125Module rec {
      pname = "tcardgen";
      version = src.rev;
      src = inputs.tcardgen-src;
      vendorHash = "sha256-X39L1jDlgdwMALzsVIUBocqxvamrb+M5FZkDCkI5XCc=";
      doCheck = false;
    };
}
