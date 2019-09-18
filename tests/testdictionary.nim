import options, unittest
import mapatei/dictionary

include common

suite "parseDictionary":
  var words: seq[DictWord]
  test "words are legal":
    words = parseDictionary()

  test "words have glosses":
    for w in words:
      check:
        w.gloss.len != 0

  test "words have definitions":
    for w in words:
      test w.display:
        check:
          w.definition.len != 0

  test "nouns have class":
    for w in words:
     if w.partOfSpeech == Noun:
       check:
         w.class.get != noClass
