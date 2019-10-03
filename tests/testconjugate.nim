import json, options, strformat, unittest
import mapatei/[conjugate, word]

suite "reduplication":
  let words = ["ondoko", "ko", "ra", "rai", "ou", "ai"]
  let expectedWords = ["ondokoo", "koko", "rara", "raira", "oujo", "aija"]

  for i, w in words.pairs:
    test fmt"{w} -> {expectedWords[i]}":
      let word = w.parse
      word.reduplicateFirstSyllable

      check $word == expectedWords[i]

suite "conjugation rules":
  var rules: Rules

  test "load rules":
    rules = loadRules()
    check:
      rules.len != 0

suite "deconjugateSuffix":
  type Case = tuple[word, suffix, want: string]
  let cases: seq[Case] = @[
    ("raja", "ja", "ra"),
    ("ondokoja", "ja", "ondoko"),
    ("amemephi", "phi", "ameme"),
    ("kīmafu", "fu", "kīma"),
  ]

  for cs in cases:
    test fmt"{cs.word} -> {cs.want}":
      let interm = deconjugateSuffix(word.parse(cs.word), cs.suffix)
      check interm == cs.want
