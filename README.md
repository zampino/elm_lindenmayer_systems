# Elm L-Systems

A basic [Lindenmayer grammar](https://en.wikipedia.org/wiki/L-system) rendered
through [Elm turtle Graphics](http://package.elm-lang.org/packages/mgold/elm-turtle-graphics/1.0.2).

Hacked with love at [Berlin Elm Hackaton](http://www.meetup.com/berlin-elm-hackathon/)
by @sotte, @despairblue and me ...

# Usage

```elm
import LSys exposing (..)
import Turtle exposing (animate)

lsys = build
  |> axiom "0"
  |> constants ["[", "]"]
  |> rules [("1", "11"), ("0", "1[0]0")]
  |> actions [ ("0",  [Forward])
    , ("1",  [Forward])
    , ("[",  [Push, Right])
    , ("]",  [Pop, Left])
    ]
  |> iterate 3

main = animate lsys
```

# Todos
- [ ] allow `Right` and `Left` types to accept a float degree param
