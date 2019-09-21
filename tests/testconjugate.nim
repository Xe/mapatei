import options, strformat, unittest
import mapatei/[conjugate, word]

suite "reduplication":
  let words = ["ondoko", "ko", "ra", "rai", "ou", "ai"]
  let expectedWords = ["ondokoo", "koko", "rara", "raira", "oujo", "aija"]

  for i, w in words.pairs:
    test fmt"{w} -> {expectedWords[i]}":
      let word = w.parse
      word.reduplicateFirstSyllable

      check $word == expectedWords[i]
