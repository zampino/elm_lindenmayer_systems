module LSys (Command(..), build, axiom, constants, rules, actions, iterate) where

import Turtle exposing (forward, left, right, penUp, penDown, Step)
import Turtle.Advanced exposing (teleport, rotateTo)
import Dict
import String
import Graphics.Element exposing (show)
import Debug
import Dict exposing (Dict, fromList, get)
import LSysConfig exposing (LSysConfig)

-- def delegate --

build = LSysConfig.build
axiom = LSysConfig.axiom
constants = LSysConfig.constants
rules = LSysConfig.rules

type Command =
  Forward | Left | Right | Pop | Push

type alias C = Command

actions : List (String, List C) -> LSysConfig C -> LSysConfig C
actions list config =
  { config | actions = config.actions ++ list }

iterate : Int -> LSysConfig C -> List Step
iterate times config =
  let
    expanded = Debug.log "expanded" (expand_times times config.axiom config)
    splitted = Debug.log "splitted" (String.split "" expanded)
    mapped = Debug.log "mapped" (List.map (mapCharToAction config) splitted)
    command_list = List.concat mapped
    final_state = reduce command_list
  in
    final_state.steps

rules_and_constants : LSysConfig C -> Dict String String
rules_and_constants config =
  let
    rules = config.rules
    rulify = \char -> (char, char)
    pairs =
      rules |> List.append (List.map rulify config.constants)
  in
    fromList pairs

mapper : LSysConfig C -> String -> String
mapper config chr =
  case get chr (rules_and_constants config) of
    Maybe.Just substitution ->
      substitution
    Maybe.Nothing ->
      ""
expand : String -> LSysConfig C -> String
expand input config =
  let
    inputList =
      String.split "" input
    mappedList =
      List.map (mapper config) inputList
  in
    String.join "" mappedList

expand_times : Int -> String -> LSysConfig C -> String
expand_times d input config =
  case d of
    0 -> input
    _ -> expand_times (d - 1) (expand (Debug.log "intermediate" input) config) config

type alias Pose = (Float, Float, Float)

type alias State = {
  position : Pose,
  stack : List Pose,
  steps : List Step
}

back : State -> State
back state =
  case state.stack of
    [] -> state -- Debug.crash "Failed."
    hd :: tl ->
      let
        (x, y, angle) = hd
      in
        { state |
          stack = tl,
          steps = state.steps ++ [penUp, teleport (x, y), penDown, rotateTo angle],
          position = hd
        }

newPose (x, y, theta) =
  let
    (xOffset, yOffset) = fromPolar (10.0, theta |> degrees)
  in
    (x + xOffset, y + yOffset, theta)

newDirection (x, y, theta) deg =
  (x, y, theta + deg)

action : C -> State -> State
action command state =
  case command of
    Push ->    -- LSysConfig.Push ->
      { state | stack = state.position :: state.stack }
    Pop ->    -- LSysConfig.Pop ->
      back state
    Forward ->    -- LSysConfig.Forward ->
      { state |
        steps = state.steps ++ [forward 10],
        position = newPose state.position
       }
    Left ->    -- LSysConfig.Left ->
      { state |
        steps = state.steps ++ [left 45],
        position = newDirection state.position 45
      }
    Right ->    -- LSysConfig.Right ->
      { state |
        steps = state.steps ++ [right 45],
        position = newDirection state.position -45
      }

initState = {
    position = (0.0, 0.0, 90),
    stack = [],
    steps = []
  }

reduce cl =
  List.foldl (\c acc -> action c acc) initState cl

mapCharToAction : LSysConfig C -> String -> List Command
mapCharToAction config chr =
  let
    dict = fromList config.actions
  in
    case get chr dict of
      Maybe.Nothing -> []
      Maybe.Just list -> list
