import strformat, unittest

import mapatatei/letters

suite "unstress":
  const
    vowels = ["a", "e", "i", "o", "u"]
    stVowels = ["ā", "ē", "ī", "ō", "ū"]

  for i, v in stVowels.pairs:
    test fmt"{v} -> {vowels[i]}":
      assert v.unstress == vowels[i]

suite "Letter":
  const words = ["ondko", "pirumi", "kho", "lundose", "thelitheli"]

  for word in words:
    test word:
      for l in word.letters:
        echo l
