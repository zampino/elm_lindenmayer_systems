import Turtle exposing (..)
import Turtle.Advanced exposing (..)
import Dict
import String
import Graphics.Element exposing (show)
import Debug

rules =
  Dict.fromList
    [ ("0", "1[0]0")
    , ("1", "11")
    ]

mapper : String -> String
mapper chr =
  case Dict.get chr rules of
    Maybe.Just substitution ->
      substitution
    Maybe.Nothing ->
      ""

expand : String -> String
expand input =
  let
    inputList =
      String.split "" input
    mappedList =
      List.map mapper inputList
  in
    String.join "" mappedList

expand_times : Int -> String -> String
expand_times d input =
  case d of
    0 -> input
    _ -> expand_times (d - 1) (expand (Debug.log "intermediate" input))

type alias Pose = (Float, Float, Float)

type alias State = {
  position : Pose,
  stack : List Pose,
  steps : List Step
}

type Command =
  Forward | Left | Right | Pop | Push

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

action : Command -> State -> State
action command state =
  let
    _ = Debug.log "state" state
  in
  case command of
    Push ->
      { state | stack = state.position :: state.stack }
    Pop ->
      back state
    Forward ->
      { state |
        steps = state.steps ++ [forward 10],
        position = newPose state.position
       }
    Left ->
      { state |
        steps = state.steps ++ [left 45],
        position = newDirection state.position 45
      }
    Right ->
      { state |
        steps = state.steps ++ [right 45],
        position = newDirection state.position -45
      }

initState = {
    position = (0.0, 0.0, 90.0),
    stack = [],
    steps = []
  }

-- command_list = [Forward, Push, Left, Forward, Left, Forward, Pop, Forward]
command_list =
  expand_times 3 "0"
  |> String.split ""
  |> List.map mapCharToAction
  |> List.foldl (\actions acc -> List.append actions acc) []

reduce command_list =
  List.foldl (\c acc -> action c acc) initState command_list

mapCharToAction chr =
  case chr of
    "0" -> [Forward]
    "1" -> [Forward]
    "[" -> [Push, Left]
    "]" -> [Pop, Right]
    _ -> Debug.crash "doh"


main = -- show (expand_times 1 "0") --animate steps
  animate ( .steps (reduce command_list) )
