module LSysConfig (LSysConfig, build, axiom, constants, rules, actions) where
import Turtle exposing (Step)

type alias Rule = (String, String)

type alias LSysConfig c =
  { axiom : String
  , constants : List String
  , rules : List Rule
  , actions : List (String, List c)
  }

build : LSysConfig c
build =
  { axiom = ""
  , constants = []
  , rules = []
  , actions = []
  }

axiom : String -> LSysConfig c -> LSysConfig c
axiom str config =
  { config | axiom = str }

constants : List String -> LSysConfig c -> LSysConfig c
constants list config =
  { config | constants = config.constants ++ list }

rules : List Rule -> LSysConfig c -> LSysConfig c
rules list config =
  { config | rules = config.rules ++ list }

actions : List (String, List c) -> LSysConfig c -> LSysConfig c
actions list config =
  { config | actions = config.actions ++ list }
