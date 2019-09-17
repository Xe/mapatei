import strformat
import syllable

type
  Word* = object
    syllables*: seq[Syllable]

  InvalidWord* = object of Exception

proc `$`*(w: Word): string =
  for s in w.syllables:
    result = result & s.display

proc parse*(word: string): Word =
  var first = true

  for syll in word.syllables:
    if not first and syll.stressed:
      raise newException(InvalidWord, "cannot have a stressed syllable here")

    if first:
      first = false

    result.syllables.add syll

