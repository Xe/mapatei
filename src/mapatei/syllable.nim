import options, strformat
import fsm
import letters

type
  Syllable* = object of RootObj
    consonant*: Option[Letter]
    vowel*: Letter
    stressed*: bool

  State {.pure.} = enum
    Init = "stateInit",
    Consonant = "stateConsonant",
    Vowel = "stateVowel",
    End = "stateEnd"

  Event {.pure.} = enum
    Consonant = "eventConsonant",
    Vowel = "eventVowel",
    EndOfInput = "eventEndOfInput"

proc display*(s: Syllable): string =
  if s.consonant.isSome:
    result = result & s.consonant.get.value
  if s.stressed:
    result = result & s.vowel.value.stress
  else:
    result = result & s.vowel.value

proc toEvent(l: Letter): Event =
  if l.isVowel:
    result = Event.Vowel
  else:
    result = Event.Consonant

iterator syllables*(word: string): Syllable =
  var m = newMachine[State, Event](State.Init)
  m.addTransition(State.Init, Event.Consonant, State.Consonant)
  m.addTransition(State.Init, Event.Vowel, State.Vowel)
  m.addTransition(State.Consonant, Event.Vowel, State.Vowel)
  m.addTransition(State.Vowel, Event.Consonant, State.End)
  m.addTransition(State.Vowel, Event.Vowel, State.End)
  m.addTransition(State.Vowel, Event.EndOfInput, State.End)

  var
    curr: Syllable

  for l in word.letters:
    # echo l
    let old = m.getCurrentState
    let ev = l.toEvent
    m.process ev

    let new = m.getCurrentState
    # echo fmt"{old}, {ev} -> {new}"
    if new == State.End:
      yield curr
      curr = Syllable()
      fsm.reset(m)

    case ev
    of Event.Vowel:
      curr.vowel = l
      curr.stressed = l.stressed
    of Event.Consonant:
      assert curr.consonant.isNone
      curr.consonant = some l
    else:
      assert false

    #echo curr

  m.process Event.EndOfInput
  assert m.getCurrentState == State.End
  yield curr
