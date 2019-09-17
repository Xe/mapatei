import unittest
import mapatei/coda

suite "Coda":
  const words = ["pirumi", "kho", "lundose", "thelitheli", "fōmbu"]

  for w in words:
    test w:
      var count = 0
      for coda in w.codas:
        echo coda
        count += 1

      assert count != 0
