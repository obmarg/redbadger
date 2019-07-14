module Input exposing (Input, RobotInput, RobotInputs, parse, robotInputParser)

{-| This module parses our Input from a string.

-}

import Maybe.Extra
import Parser exposing ((|.), (|=), Parser, Step(..), end, int, loop, map, oneOf, spaces, succeed, symbol, variable)
import Robot exposing (Coord, Instruction(..), Orientation(..), RobotPosition(..), RobotState(..))
import Set


type alias RobotInput =
    { startingState : RobotState, instructions : List Instruction }


type alias RobotInputs =
    List RobotInput


type alias Input =
    { maxCoords : Coord, robots : List RobotInput }


parse : String -> Result (List Parser.DeadEnd) Input
parse =
    Parser.run parser


parser : Parser Input
parser =
    succeed Input
        |= coordParser
        |. spaces
        |= loop [] robotsParserHelp
        --|= (robotInputParser |> Parser.map List.singleton)
        |. end


coordParser : Parser Coord
coordParser =
    succeed (\x y -> ( x, y ))
        |= int
        |. spaces
        |= int


orientationParser : Parser Orientation
orientationParser =
    oneOf
        [ "N" |> symbol |> map (\_ -> North)
        , "S" |> symbol |> map (\_ -> South)
        , "E" |> symbol |> map (\_ -> East)
        , "W" |> symbol |> map (\_ -> West)
        ]


robotsParserHelp : RobotInputs -> Parser (Step RobotInputs RobotInputs)
robotsParserHelp revInputs =
    oneOf
        [ succeed (\stmt -> Loop (stmt :: revInputs))
            |= robotInputParser

        , succeed
            ()
            |> map (\_ -> Done (List.reverse revInputs))
        ]


robotInputParser : Parser RobotInput
robotInputParser =
    succeed
        (\coords orientation instructions ->
            RobotInput (KnownPosition (RobotPosition coords orientation)) instructions
        )
        |= coordParser
        |. spaces
        |= orientationParser
        |. spaces
        |= instructionsParser
        |. spaces


instructionsParser : Parser (List Instruction)
instructionsParser =
    let
        isInstructionChar c =
            c == 'F' || c == 'L' || c == 'R'
    in
    variable
        { start = isInstructionChar
        , inner = isInstructionChar
        , reserved = Set.empty
        }
        |> Parser.andThen
            (\str ->
                str
                    |> String.toList
                    |> List.map charToInstruction
                    |> Maybe.Extra.combine
                    |> maybeToParser
            )


charToInstruction : Char -> Maybe Instruction
charToInstruction c =
    case c of
        'R' ->
            Just TurnRight

        'L' ->
            Just TurnLeft

        'F' ->
            Just MoveForward

        _ ->
            Nothing


maybeToParser : Maybe a -> Parser a
maybeToParser m =
    case m of
        Just x ->
            succeed x

        Nothing ->
            Parser.problem "Unexpected instruction character"
