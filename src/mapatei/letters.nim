import options, strformat, unicode

type
  Letter* = object of RootObj
    case isVowel*: bool
    of true:
      stressed*: bool
    of false: discard
    value*: string

const
  simpleConsonants = ["f", "j", "l", "r", "s", "w", "y"]
  complexConsonants = ["k", "m", "n", "p", "t"]
  vowels = ["a", "e", "i", "o", "u"]
  stVowels = ["ā", "ē", "ī", "ō", "ū"]

proc stress*(s: string): string =
  if not (s in vowels):
    return s
  proc replacement(key: string): string =
    let i = vowels.find(key)
    assert i != -1
    stVowels[i]
  s.translate replacement

proc unstress*(s: string): string =
  if not (s in stVowels):
    return s
  proc replacement(key: string): string =
    let i = stVowels.find(key)
    assert i != -1
    vowels[i]
  s.translate replacement

iterator letters*(inp: string): Letter =
  var
    runes = inp.toRunes
    skip = false

  for i, rune in runes.pairs:
    if skip:
      skip = false
      continue

    template yieldVowel() =
      yield Letter(isVowel: true, stressed: false, value: $rune)
    template yieldStVowel() =
      yield Letter(isVowel: true, stressed: true, value: unstress $rune)
    template yieldConsonantSimple() =
      yield Letter(isVowel: false, value: unstress $rune)
    template yieldComplexConsonant(val: string) =
      skip = true
      yield Letter(isVowel: false, value: val)
    template yieldComplexConsonantIfOneLetter(nextCmp: string) =
      if next == nextCmp:
        yieldComplexConsonant($rune & nextCmp)
      else:
        yieldConsonantSimple()

    if $rune in vowels:
      yieldVowel()
    elif $rune in stVowels:
      yieldStVowel()
    elif $rune in simpleConsonants:
      yieldConsonantSimple()
    elif $rune in complexConsonants:
      let next = $runes[i+1]

      case $rune
      of "k":
        yieldComplexConsonantIfOneLetter("h")

      of "m":
        yieldComplexConsonantIfOneLetter("b")

      of "n":
        case next
        of "d":
          yieldComplexConsonant("nd")
        of "g":
          yieldComplexConsonant("ng")
        else:
          yieldConsonantSimple()

      of "p":
        yieldComplexConsonantIfOneLetter("h")

      of "t":
        yieldComplexConsonantIfOneLetter("h")

