import options, tables, parsecsv, streams, strutils
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
  ruleData = slurp "conjugationRules.csv"

type
  Rule* = object
    partOfSpeech*: PartOfSpeech
    name*: string
    suffix*: string
    prefixWord*: Option[Word]
    reduplicateFirstSyllable*: bool

  Rules* = seq[Rule]

proc loadRules*(): Rules =
  var s = ruleData.newStringStream
  doAssert s != nil, "can't open this as a stream???"

  var cp: CsvParser
  cp.open s, "rules data"
  cp.readHeaderRow

  while cp.readRow:
    let row = cp.row
    var rule = Rule(
      partOfSpeech: parseEnum[PartOfSpeech](row[0]),
      name: row[1],
      suffix: row[2],
      reduplicateFirstSyllable: row[4] == "true",
    )

    if row[3] != "":
      rule.prefixWord = some word.parse(row[3])

    result.add rule
