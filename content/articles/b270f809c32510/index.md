---
date: '2025-11-27T00:00:00+09:00'
draft: false
title: 'HugoにNixをひらく'
author:
  - '@ttak0422'
tags:
  - 'hugo'
  - 'nix'
categories:
  - 'articles'
---
> **Tips**
> Nixのセットアップ方針について[最小Nix堅牢構成]({{< ref "/articles/8fd90d71050d79" >}})に記載している。

このブログへの適用例を記す。

## 環境構築
`hugo`と`textlint`が動作する環境を作る。Nixでどこまでの管理をするか、線引きが重要である。

hugoのようなシングルバイナリツールはNixと相性が良い。大方標準で提供されるためそれを利用する。

textlintのようなNode.jsパッケージ群はNixと相性が良くない。Node.jsの世界をNixで再定義することは難しかった。
現在はランタイムやパッケージマネージャの導入にだけNixを利用し、以降の詳細な作業は本家に移譲するのが良いとされている。

## コンテンツのビルド

### テーマ
[typo](https://github.com/tomfran/typo)を採用した。これもNixで管理する。
layouts側で上書きする作法に従えば、基本的な要求は満たせる。

```nix
# flake.nix
devShells.default = pkgs.mkShell {

  shellHook = ''
    mkdir -p themes
    ln -snf ${pkgs.typo} themes/typo
  '';
};
```

### OGP画像
[tcardgen](https://github.com/Ladicle/tcardgen)を採用した。[^1]当然Nixで管理する。
厳格なNixの世界ではGo製モジュールは言語バージョンに紐付けて管理する方向に進んでいる。

```nix
# nix/overlays.nix
tcardgen = buildGo125Module rec {
  pname = "tcardgen";
  version = src.rev;
  src = inputs.tcardgen-src;
  vendorHash = "sha256-X39L1jDlgdwMALzsVIUBocqxvamrb+M5FZkDCkI5XCc=";
  doCheck = false;
};
```

tcardgenは汎用的な設定がされている。個人ブログであろうとFrontMatterにはauthorの設定が要求される。
都度自分で設定するのは面倒だが、hugoの記事テンプレートで対応する(archetypes/articles.md)。

```markdown
---
date: '{{ .Date }}'
draft: true
title: ''
author:
  - '@ttak0422'
tags:
categories:
  - 'articles'
---
```

画像生成の際はディレクトリを指定してMarkdownファイル名に対応したファイルの一括生成か、ファイル名を指定しての個別生成が可能だ。
`content/posts/*/index.md` のようなパスを採用しているのでbashで対応する。
[YAGNI](https://ja.wikipedia.org/wiki/YAGNI)は偉大。計算機器は十分に高速なのだ。
パフォーマンスがネックになるような嬉しい問題が出ることには別のアプローチを思い付いているだろう。

```nix
buildPhase = ''
  # ...
  ln -snf ${pkgs.typo} themes/typo
  # og image
  for x in content/posts/*/index.md content/articles/*/index.md; do
    [ -f "$x" ] || continue
    id=$(basename "$(dirname "$x")")
    tcardgen \
      --fontDir tcardgen \
      --config tcardgen/blog.yaml \
      --output "static/og/$id.png" \
      -t tcardgen/blog.png \
      "$x"
  done
  # ...
'';
```

[^1]:先駆者がいたので参考にする[tcardgenをnixでパッケージ化する方法](https://www.takeokunn.org/posts/fleeting/20241122091116-how_to_package_tcardgen_with_nix/)。
