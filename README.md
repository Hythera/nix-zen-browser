<p align="center">
    <a href="https://zen-browser.app/"><img src=".github/assets/nix-zen-browser.png" alt="Nix Zen Browser" height=170></a>
</p>
<h1 align="center">Nix Zen Browser</h1>

<p align="center">
<a href="https://zen-browser.app/download/"><img src="https://img.shields.io/badge/version-1.19.3b-blue" alt="version"/></a>
<a href="https://github.com/Hythera/nix-zen-browser/stargazers"><img src="https://img.shields.io/github/stars/Hythera/nix-zen-browser" alt="stars"/>
</p>

<div align="center">
  <a href="https://zen-browser.app/">Zen Browser</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://github.com/Hythera/nix-zen-browser/issues/new">Issues</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://zen-browser.app/release-notes/">Changelog</a>
  <br />
</div>

> [!Note]
> This flake is experimental. While I will try to keep it updated, I can't garuantee just in time security updates until Zen Browser gets adopted into **nixpkgs**.

## What is Nix Zen Browser?

Since Zen isn't currently in **nixpkgs**, this flake implements both the `zen-browser` and the `zen-browser-bin` version of it. Zen isn't currently in **nixpkgs** since there is no **commiter** who is willing to maintain it. If you are interested in the progress, you can checkout https://github.com/NixOS/nixpkgs/pull/496647.

## Installation

This flake supports `x86_64` & `aarch64` for both Linux and Darwin. Note `zen-browser-bin` only supports `x86_64-linux` and `aarch64-linux`, so if you want to use Zen on Darwin, you have to use the from-source build.

### Running Zen in a Nix-Shell

You can test Zen on your system by running it in a **Nix-Shell**. It is recommendet to use the `-bin` package for this.

```bash
# Run the Nix-Shell (requires the new experimental Nix command)
nix shell github:Hythera/nix-zen-browser#zen-browser-bin

# Start Zen
zen
```

### System Package

The second way is to install Zen on your NixOS system. While you can use the `zen-browser` package, it is recommended to use the `zen-browser-bin` package, as the from-source build can take up to 2 hours depending on your system. If you don't want to install Zen globally, you can use tools like **home-manager**. Just use `home.packages` instead of `environment.systemPackages` in you home-configuration.

```nix
# flake.nix
{
  inputs = {
    zen-browser.url = "github:Hythera/nix-zen-browser";
    ...
  };
  outputs = {
    nixpkgs,
    ...
  }: let
    system = "...";
    in {
      nixosConfigurations."..." = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./configuration.nix
          ...
        ];
      };
    }
}
```

```nix
# configuration.nix
{ 
  inputs,
  pkgs, 
  ...
}:
{
  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.system}.zen-browser-bin
  ]
}
```
