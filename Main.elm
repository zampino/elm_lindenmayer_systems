import LSys exposing (..)
import Turtle exposing (animate)

lsys = build
  |> axiom "0"
  |> constants ["[", "]"]
  |> rules
    [ ("1", "11")
    , ("0", "1[0]0")
    ]
  |> actions
    [ ("0",  [Forward])
    , ("1",  [Forward])
    , ("[",  [Push, Right])
    , ("]",  [Pop, Left])
    ]
  |> iterate 4

-- lsys = build
--   |> axiom "FX"
--   |> constants ["+", "-"]
--   |> rules [("X", "X+FY"), ("Y", "FX-Y")]
--   |> actions
--     [ ("F",  [Forward])
--     , ("+",  [Right])
--     , ("-",  [Left])
--     ]
--   |> iterate 10

main = animate lsys
