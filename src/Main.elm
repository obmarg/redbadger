module Main exposing (main)

import Browser
import Html exposing (..)


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
    model


view : Model -> Html Msg
view model =
    h1 [] [ text "Hello" ]



-- TODO: Tests, then write a parser.
