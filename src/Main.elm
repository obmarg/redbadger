module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Input exposing (Input)
import Robot
import Set
import Tuple


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { input : String
    , output : String
    }


init : Model
init =
    Model "" ""


type Msg
    = UpdateInput String
    | RunScript


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput input ->
            { model | input = input }

        RunScript ->
            let
                output =
                    model.input
                        |> Input.parse
                        |> Result.map runInput
                        |> Result.withDefault "Parse error"
            in
            { model | output = output }


view : Model -> Html Msg
view model =
    div []
        [ text "Input"
        , textarea [ onInput UpdateInput ] [ text model.input ]
        , text "Output"
        , textarea [] [ text model.output ]
        , button [ onClick RunScript ] [ text "Process" ]
        ]


formatOutput x y orientation isLost =
    String.join " "
        [ String.fromInt x
        , String.fromInt y
        , orientationToString orientation
        , if isLost then
            "LOST"

          else
            ""
        ]


orientationToString : Robot.Orientation -> String
orientationToString orientation =
    case orientation of
        Robot.North ->
            "N"

        Robot.South ->
            "S"

        Robot.West ->
            "W"

        Robot.East ->
            "E"


runInput : Input -> String
runInput input =
    let
        stateToString state =
            let
                ( Robot.RobotPosition ( x, y ) orientation, lost ) =
                    case state of
                        Robot.KnownPosition pos ->
                            ( pos, False )

                        Robot.Lost pos ->
                            ( pos, True )
            in
            formatOutput x y orientation lost
    in
    input
        |> Robot.runInput
        |> List.map stateToString
        |> String.join "\n"
