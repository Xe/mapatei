import strformat, unittest
import mapatei
import mapatei/fsm

include common

suite "parse":
  for word in words:
    test fmt"legal word {word}":
      discard parse(word)

  const illegalWords = ["fōmbufōmbu", "akhlō"]

  for word in illegalWords:
    test fmt"illegal word {word}":
      expect(InvalidWord, AssertionError, TransitionNotFoundException):
        discard parse(word)
