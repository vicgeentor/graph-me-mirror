{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    agda = {
      url = "github:agda/agda/v2.9.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem =
        { pkgs, lib, ... }:
        let
          # Currently using the Agda flake to use Agda version 2.9.0.
          # This can be removed once 2.9.0 is in nixpkgs
          agdaPkgs = pkgs.agdaPackages.override {
            Agda = inputs.agda.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
        in
        {
          packages = rec {
            graph-me = agdaPkgs.mkDerivation {
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
              (agdaPkgs.agda.withPackages (p: [
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
