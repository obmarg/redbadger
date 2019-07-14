module RobotTests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Input exposing (Input)
import Robot exposing (..)
import Set
import Test exposing (..)


suite : Test
suite =
    describe "The Robot Module"
        [ describe "Robot.followInstructions"
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
        , describe "Robot.runInput"
            [ test "can run some input" <|
                \_ ->
                    let
                        input =
                            Input ( 5, 3 )
                                [ { startingState = KnownPosition (RobotPosition ( 1, 1 ) East)
                                  , instructions =
                                        [ TurnRight
                                        , MoveForward
                                        , TurnRight
                                        , MoveForward
                                        , TurnRight
                                        , MoveForward
                                        , TurnRight
                                        , MoveForward
                                        ]
                                  }
                                , { startingState = KnownPosition (RobotPosition ( 3, 2 ) North)
                                  , instructions =
                                        [ MoveForward
                                        , TurnRight
                                        , TurnRight
                                        , MoveForward
                                        , TurnLeft
                                        , TurnLeft
                                        , MoveForward
                                        , MoveForward
                                        , TurnRight
                                        , TurnRight
                                        , MoveForward
                                        , TurnLeft
                                        , TurnLeft
                                        ]
                                  }
                                , { startingState = KnownPosition (RobotPosition ( 0, 3 ) West)
                                  , instructions =
                                        [ TurnLeft
                                        , TurnLeft
                                        , MoveForward
                                        , MoveForward
                                        , MoveForward
                                        , TurnLeft
                                        , MoveForward
                                        , TurnLeft
                                        , MoveForward
                                        , TurnLeft
                                        ]
                                  }
                                ]

                        result =
                            runInput input
                    in
                    Expect.equal result
                        [ KnownPosition (RobotPosition ( 1, 1 ) East)
                        , Lost (RobotPosition ( 3, 3 ) North)
                        , KnownPosition (RobotPosition ( 2, 3 ) South)
                        ]
            ]
        ]


startingState : RobotState
startingState =
    KnownPosition (RobotPosition ( 0, 0 ) East)


testInstructions : List Instruction -> RobotState
testInstructions =
    followInstructions ( 3, 3 ) Set.empty startingState
