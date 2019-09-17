import options
import fsm
import letters

type
  Coda* = object
    consonant*: Option[Letter]
    vowel*: Letter
    stressed*: bool
