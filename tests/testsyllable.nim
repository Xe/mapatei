import unittest
import mapatei/syllable

suite "Syllable":
  const words = ["pirumi", "kho", "lundose", "thelitheli", "fōmbu"]

  for w in words:
    test w:
      var count = 0
      for syllable in w.syllables:
        echo syllable
        count += 1

      assert count != 0
