{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem =
        { pkgs, lib, ... }:
        {
          packages = rec {
            call-me = pkgs.agdaPackages.mkDerivation {
              pname = "call-me";
              version = "0.1";
              src = ./.;
              meta = {
                description = "Agda library for automatic call graph generation from function definitions";
                homepage = "https://codeberg.org/vicgeentor/call-me";
                license = lib.licenses.mit;
                platforms = lib.platforms.unix;
              };
            };
            default = call-me;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              (pkgs.agda.withPackages (p: [
                p.standard-library
              ]))
              pkgs.ghc
            ];
          };
        };
    };
}
