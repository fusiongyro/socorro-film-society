{
  description = "Website and software for the Socorro Film Society";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import an internal flake module: ./other.nix
        # To import an external flake module:
        #   1. Add foo to inputs
        #   2. Add foo as a parameter to the outputs function
        #   3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;
        
        devShells.default = let
            # this is needed because the 0.10.0 version has a bug with HTTP services
            scryer-prolog-http-patched = pkgs.scryer-prolog.overrideAttrs (attrs: {
              src = pkgs.fetchFromGitHub {
                owner = "danilp-id";
                repo = "scryer-prolog";
                rev = "337d9c5";
                sha256 = "sha256-4wE+KMbxIHv+ZeV5YZYFT1Ieqv4usZamwuUukTIDeLA=";
              };
            });
          in
            pkgs.mkShell {
              packages = [pkgs.wget pkgs.swi-prolog scryer-prolog-http-patched];
            };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
