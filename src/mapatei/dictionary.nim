import options, parsecsv, streams, strformat, strutils
import word

type
  PartOfSpeech* = enum
    Noun = "Noun",
    Verb = "Verb",
    Conjunction = "Conjunction",
    Preposition = "Preposition",
    Determiner = "Determiner",
    Interjection = "Interjection"
    Numeral = "Numeral",
    Pronoun = "Pronoun"

  NounClass* = enum
    noClass,
    human = "human",
    animal = "animal",
    animate = "animate",
    inanimate = "inanimate"

  DictWord* = object
    word*: seq[Word]
    gloss*: string
    partOfSpeech*: PartOfSpeech
    class*: Option[NounClass]
    definition*: string

  WordParsingError* = object of Exception

const
  conjunctions* = slurp "./dictionary/Conjunction.csv"
  determiners* = slurp "./dictionary/Determiner.csv"
  interjections* = slurp "./dictionary/Interjection.csv"
  nouns* = slurp "./dictionary/Noun.csv"
  numerals* = slurp "./dictionary/Numeral.csv"
  prepositions* = slurp "./dictionary/Preposition.csv"
  pronouns* = slurp "./dictionary/Pronoun.csv"
  verbs* = slurp "./dictionary/Verb.csv"
  dictFiles = [conjunctions, determiners, interjections, nouns, numerals, prepositions, pronouns, verbs]
  classHeaderName = "CLASS(ES)"

proc display*(dw: DictWord): string =
  for i, w in dw.word.pairs:
    if i != 0:
      result &= " "
    result &= $w

  result &= fmt" ({dw.partOfSpeech})"

proc parseDictionaryStream(cp: var CsvParser): seq[DictWord] =
  let locOfClass = cp.headers.find classHeaderName
  try:
    while cp.readRow:
      let row = cp.row
      var words: seq[Word]

      for w in row[0].split " ":
        words.add w.parse

      let
        gloss = row[1]
        pos = parseEnum[PartOfSpeech] row[2]
        class = parseEnum[NounClass](row[locOfClass], noClass)
        def = row[row.len - 1]
      var actualClass: Option[NounClass]
      if class != noClass:
        actualClass = some class
      result.add DictWord(
        word: words,
        gloss: gloss,
        partOfSpeech: pos,
        class: actualClass,
        definition: def,
      )
  except:
    echo fmt"{cp.row[0]} fails morphology checking: {getCurrentExceptionMsg()}"
    raise newException(WordParsingError, fmt"word parsing error {cp.row[0]}: {getCurrentExceptionMsg()}")

proc parseDictionary*(): seq[DictWord] =
  for csvFile in dictFiles:
    var s = csvFile.newStringStream
    doAssert s != nil, "can't open this as a stream???"

    var cp: CsvParser
    cp.open s, "dictionary data"
    cp.readHeaderRow
    let data = cp.parseDictionaryStream
    for dw in data:
      result.add dw
