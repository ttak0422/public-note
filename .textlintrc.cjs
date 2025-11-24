module.exports = {
  filters: {
    comments: true,
    "node-types": {
      nodeTypes: [
        "Yaml",
        "Toml",
        "FrontMatter",
        "Header",
        "ListItem",
        "Code",
        "CodeBlock",
        "CodeBlockFence",
        "Math",
        "Link",
        "Image"
      ]
    }
  },
  rules: {
    "@textlint-ja/preset-ai-writing": true,
    "preset-japanese": {
      "sentence-length": false,
      "max-kanji-continuous-len": {
        max: 6
      }
    },
    "preset-ja-technical-writing": {
      "sentence-length": false,
      "max-kanji-continuous-len": false,
      "no-mix-dearu-desumasu": {
        preferInHeader: "である",
        preferInBody: "である",
        preferInList: "である",
        preferInQuote: "である",
        strict: false
      }
    },
    "japanese/sentence-length": false,
    "ja-technical-writing/sentence-length": false,
    "preset-jtf-style": {
      "3.3.かっこ類と隣接する文字の間のスペースの有無": false
    },
    "no-mix-dearu-desumasu": {
      preferInHeader: "である",
      preferInBody: "である",
      preferInQuote: "である"
    }
  }
};
