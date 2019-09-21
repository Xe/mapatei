import json, options, tables, strformat, strutils
import dictionary, letters, syllable, word

type
  Tense* = enum
    noTense,
    Future = "future",
    Present = "present",
    Past = "past"

let bufferLetter = Letter(
  isVowel: false,
  value: "j",
)

proc reduplicateFirstSyllable*(w: Word) =
  var s: Syllable
  deepCopy s, w.syllables[0]
  s.stressed = false

  if w.syllables.len >= 2:
    let
      penultimate = w.syllables[w.syllables.len - 2]
      ultimate = w.syllables[w.syllables.len - 1]

    if penultimate.consonant.isNone and ultimate.consonant.isNone:
      s.consonant = some bufferLetter

  w.syllables.add s

const
  rulesData = slurp "conjugationRules.json"

type
  Rule = object
    suffix: string
    prefixWord: string
    reduplicateFirstSyllable: bool

  Rules = OrderedTable[PartOfSpeech, OrderedTable[string, Rule]]

let rules: Rules = rulesData.parseJson.to Rules
