import strformat, unittest

import mapatei/letters

suite "unstress":
  const
    vowels = ["a", "e", "i", "o", "u"]
    stVowels = ["ā", "ē", "ī", "ō", "ū"]

  for v in vowels:
    test fmt"{v} -> {v}":
      assert v.unstress == v

  for i, v in stVowels.pairs:
    test fmt"{v} -> {vowels[i]}":
      assert v.unstress == vowels[i]

suite "Letter":
  const words = ["pirumi", "kho", "lundose", "thelitheli", "fōmbu"]

  for word in words:
    test word:
      for l in word.letters:
        echo l
