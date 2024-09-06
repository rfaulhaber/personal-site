{
  description = "personal-site";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
            inherit system;
          };
          projectName = "personal-site";
      in {
        packages.default = self.packages.${system}.${projectName};
        apps.${projectName} = flake-utils.lib.mkApp {drv = self.packages.${projectName};};

        apps.default = self.apps.${system}.${projectName};

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ hugo ];
        };
      }
    );
}
