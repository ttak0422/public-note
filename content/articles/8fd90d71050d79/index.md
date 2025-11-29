---
date: '2025-11-26T00:00:00+09:00'
draft: false
title: '最小Nix堅牢構成'
author:
  - '@ttak0422'
tags:
  - 'nix'
categories:
  - 'articles'
---
> **INFO**
> 本ブログもNixを利用している。具体例を下記に記載している。
> - [HugoにNixをひらく]({{< ref "/articles/b270f809c32510" >}})

## 基本方針

[flake-parts](https://github.com/hercules-ci/flake-parts)を利用する。

devShellsとdefault定義だけ利用する要素(packages, checks, apps, etc.)を記述する。

増えるだろう要素、込み入った定義になる要素は`nix`フォルダ配下で定義しimportする。

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    /* ... */
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          system,
          pkgs,
          lib,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (import ./nix/overlays.nix { inherit inputs; })
            ];
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ /* ... */ ];
            shellHook = /* ... */
          };
        };
    };
}
```

```nix
# nix/overlays.nix
{ inputs }:
final: _:
{ /* ... */ }
```
