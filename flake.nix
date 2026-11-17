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
            graph-me = pkgs.agdaPackages.mkDerivation {
              pname = "graph-me";
              version = "0.1";
              src = ./.;
              meta = {
                description = "Agda library for automatic function graph generation from function definitions";
                homepage = "https://codeberg.org/vicgeentor/graph-me";
                license = lib.licenses.mit;
                platforms = lib.platforms.unix;
              };
            };
            default = graph-me;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              (pkgs.agda.withPackages (p: [
                p.standard-library
              ]))
              pkgs.ghc
              (pkgs.python3.withPackages (
                ps: with ps; [
                  mdformat
                  mdformat-gfm
                  mdformat-gfm-alerts
                  mdformat-myst
                ]
              ))
            ];
          };
        };
    };
}
