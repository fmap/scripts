{ pkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/tarball/e9e6d62c59573e250c518e59a097cdf35a471ff8") {}
, lib ? pkgs.lib
}: let
  compileShell = script: buildInputs: name: pkgs.stdenv.mkDerivation {
    inherit name buildInputs;
    src = pkgs.writeScript "compile-${name}" ''
      export PATH="${lib.makeSearchPath "bin" buildInputs}"
      ${script} $*
    '';
    unpackPhase = "true";
    installPhase = "mkdir -p $out/bin && cp $src $out/bin/${name}";
  };
  compileHaskell = script: buildInputs: name: let
    binary = pkgs.runCommand name {} ''
      src="$TMPDIR/${name}.hs" # N.B. ".hs.hs" compiles, "" doesn't.
      mkdir -p $TMPDIR && cp ${script} $src
      mkdir -p $out
      ${pkgs.haskellPackages.ghcWithPackages (_: buildInputs)}/bin/ghc -o $out/${name} $src
    '';
  in compileShell "${binary}/${name}" buildInputs name; # Admit binary dependencies.
in lib.mapAttrs (k: f: f k) {
  fetch-intermediates = compileShell
    ./fetch-intermediates
    (with pkgs; [coreutils curl gawk gnugrep moreutils openssl zsh]);
  normalise-ssh-config = compileShell
    ./normalise-ssh-config
    (with pkgs; [bash coreutils gawk gnugrep]);
  persevere = compileShell
    ./persevere
    (with pkgs; [bash coreutils gnugrep]);
  temporary-iam-credentials = compileShell
    ./temporary-iam-credentials
    (with pkgs; [awscli bash coreutils gnugrep jq]);
  github-dl = compileHaskell
    ./github-dl
    (with pkgs.haskellPackages; [interpolate optparse-applicative pkgs.git string-conversions wreq]);
}
