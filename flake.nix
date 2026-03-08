{
  description = "Zen browser for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      overlays.default = final: prev: {
        zen-browser = prev.callPackage ./zen-browser/default.nix {
          zen-browser-unwrapped = final.zen-browser-unwrapped;
        };
        zen-browser-bin = prev.callPackage ./zen-browser-bin/default.nix {
          zen-browser-bin-unwrapped = final.zen-browser-bin-unwrapped;
        };
        zen-browser-bin-unwrapped = prev.callPackage ./zen-browser-bin-unwrapped/default.nix { };
        zen-browser-unwrapped = prev.callPackage ./zen-browser-unwrapped/default.nix { };
      };
    }
    // (inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        packages = {
          zen-browser = pkgs.zen-browser;
          zen-browser-bin = pkgs.zen-browser-bin;
          zen-browser-bin-unwrapped = pkgs.zen-browser-bin-unwrapped;
          zen-browser-unwrapped = pkgs.zen-browser-unwrapped;
        };
      }
    ));
}
