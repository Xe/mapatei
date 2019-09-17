import strformat, unittest
import mapatei/[fsm, syllable]

include common

suite "Syllable":
  for w in words:
    test w:
      var count = 0
      for syllable in w.syllables:
        echo fmt"result: {syllable}"
        count += 1

      assert count != 0

  const illegalWords = ["fōmbufmbu", "khlō"]

  for w in illegalWords:
    test "illegal word " & w:
      expect(AssertionError, TransitionNotFoundException):
        for s in w.syllables:
          echo fmt"result: {s}"
