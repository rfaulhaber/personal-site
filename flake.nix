{
  description = "personal-site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      perSystem = {
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        projectName = "personal-site";
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
          ];
        };
      };
    };
}
