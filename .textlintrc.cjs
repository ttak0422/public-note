module.exports = {
  filters: {},
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
      "max-kanji-continuous-len": false
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
