module RobotTests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Robot exposing (..)
import Set
import Test exposing (..)


suite : Test
suite =
    describe "Robot.followInstructions"
        [ test "robot can follow simple instructions" <|
            \_ ->
                let
                    result =
                        testInstructions [ MoveForward, TurnLeft, MoveForward, TurnRight, MoveForward ]
                in
                Expect.equal result (KnownPosition (RobotPosition ( 2, 1 ) East))
        , test "360 degree turn left" <|
            \_ ->
                let
                    result =
                        testInstructions [ TurnLeft, TurnLeft, TurnLeft, TurnLeft ]
                in
                Expect.equal result (KnownPosition (RobotPosition ( 0, 0 ) East))
        , test "360 degree turn right" <|
            \_ ->
                let
                    result =
                        testInstructions [ TurnRight, TurnRight, TurnRight, TurnRight ]
                in
                Expect.equal result (KnownPosition (RobotPosition ( 0, 0 ) East))
        , test "robot becomes lost if it goes off the map" <|
            \_ ->
                let
                    result =
                        testInstructions
                            [ MoveForward, MoveForward, MoveForward, MoveForward, TurnLeft, TurnLeft, MoveForward, MoveForward ]
                in
                Expect.equal result (Lost (RobotPosition ( 3, 0 ) East))
        , test "robot pays attention to scents" <|
            \_ ->
                let
                    instructions =
                        [ MoveForward, MoveForward, MoveForward, MoveForward, TurnLeft, TurnLeft, MoveForward, MoveForward ]

                    result =
                        followInstructions ( 3, 3 ) (Set.singleton ( 3, 0 )) startingState instructions
                in
                Expect.equal result (KnownPosition (RobotPosition ( 1, 0 ) West))
        ]


startingState : RobotState
startingState =
    KnownPosition (RobotPosition ( 0, 0 ) East)


testInstructions : List Instruction -> RobotState
testInstructions =
    followInstructions ( 3, 3 ) Set.empty startingState
