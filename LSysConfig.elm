module LSysConfig (LSysConfig, build, axiom, constants, rules) where
import Turtle exposing (Step)

type alias Rule = (String, String)

-- type Command =
--   Forward | Left | Right | Pop | Push

type alias LSysConfig a =
  { axiom : String
  , constants : List String
  , rules : List Rule
  , actions : List (String, List a)
  }

build : LSysConfig a
build =
  { axiom = ""
  , constants = []
  , rules = []
  , actions = []
  }

axiom : String -> LSysConfig a -> LSysConfig a
axiom str config =
  { config | axiom = str }

constants : List String -> LSysConfig a -> LSysConfig a
constants list config =
  { config | constants = config.constants ++ list }

rules : List Rule -> LSysConfig a -> LSysConfig a
rules list config =
  { config | rules = config.rules ++ list }

-- actions : List (String, List Command) -> LSysConfig -> LSysConfig
-- actions list config =
--   { config | actions = config.actions ++ list }
