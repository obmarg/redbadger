module InputTests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Input exposing (..)
import Parser
import Robot exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Parser.parse"
        [ test "can parse a single robots input" <|
            \_ ->
                let
                    result =
                        Input.parse "5 3\n1 1 E\nRFRL"
                in
                Expect.equal result
                    (Ok
                        (Input ( 5, 3 )
                            [ { startingState = KnownPosition (RobotPosition ( 1, 1 ) East)
                              , instructions = [ TurnRight, MoveForward, TurnRight, TurnLeft ]
                              }
                            ]
                        )
                    )
        , test "can parse multiple robots input" <|
            \_ ->
                let
                    result =
                        Input.parse "5 3\n1 1 E\nRFRL\n2 2 W\nR"
                in
                Expect.equal result
                    (Ok
                        (Input ( 5, 3 )
                            [ { startingState = KnownPosition (RobotPosition ( 1, 1 ) East)
                              , instructions = [ TurnRight, MoveForward, TurnRight, TurnLeft ]
                              }
                            , { startingState = KnownPosition (RobotPosition ( 2, 2 ) West)
                              , instructions = [ TurnRight ]
                              }
                            ]
                        )
                    )
        , test "robot input parser" <|
            \_ ->
                let
                    result =
                        Parser.run Input.robotInputParser "1 1 E\nRFRL"
                in
                Expect.equal result
                    (Ok
                        { startingState = KnownPosition (RobotPosition ( 1, 1 ) East)
                        , instructions = [ TurnRight, MoveForward, TurnRight, TurnLeft ]
                        }
                    )
        ]
