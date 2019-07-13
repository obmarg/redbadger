module Robot exposing (Coord, Instruction(..), Orientation(..), RobotPosition(..), RobotState(..), Scents, followInstructions)

{-| A module that implements our robot functionality
-}

import Set exposing (Set)


{-| A coordinate in 2d space.
-}
type alias Coord =
    ( Int, Int )


{-| The position of a robot - either they're lost or they have a known positon.
-}
type RobotPosition
    = RobotPosition Coord Orientation


{-| Robots can be in one of two states: we know their position, or they're lost
and we no longer know their position
-}
type RobotState
    = KnownPosition RobotPosition
    | Lost RobotPosition


{-| The direction a robot is currently facing.
-}
type Orientation
    = North
    | South
    | East
    | West


{-| An instruction that our robot can carry out
-}
type Instruction
    = TurnLeft
    | TurnRight
    | MoveForward


{-| We represent the "scents" of lost robots as a set of coordinates
-}
type alias Scents =
    Set Coord


turnLeft : Orientation -> Orientation
turnLeft orientation =
    case orientation of
        North ->
            West

        South ->
            East

        West ->
            South

        East ->
            North


turnRight : Orientation -> Orientation
turnRight orientation =
    case orientation of
        North ->
            East

        South ->
            West

        West ->
            North

        East ->
            South


moveForward : Coord -> Orientation -> Coord
moveForward ( x, y ) orientation =
    case orientation of
        North ->
            ( x, y + 1 )

        South ->
            ( x, y - 1 )

        West ->
            ( x - 1, y )

        East ->
            ( x + 1, y )


followInstruction : RobotPosition -> Instruction -> RobotPosition
followInstruction (RobotPosition coord orientation) instruction =
    case instruction of
        TurnLeft ->
            RobotPosition coord (turnLeft orientation)

        TurnRight ->
            RobotPosition coord (turnRight orientation)

        MoveForward ->
            RobotPosition (moveForward coord orientation) orientation


robotIsOutOfBounds : Coord -> RobotPosition -> Bool
robotIsOutOfBounds ( maxX, maxY ) (RobotPosition ( x, y ) _) =
    x < 0 || x > maxX || y < 0 || y > maxY


followInstructions : Coord -> Scents -> RobotState -> List Instruction -> RobotState
followInstructions maxCoords scents robotState instructions =
    case ( instructions, robotState ) of
        ( [], _ ) ->
            -- No more instructions, so we return the final robot state
            robotState

        ( _, Lost position ) ->
            -- Our robot got lost, so we can stop processing instructions
            robotState

        ( instruction :: restInstructions, KnownPosition position ) ->
            let
                newPosition =
                    followInstruction position instruction

                (RobotPosition robotCoords _) =
                    position
            in
            case ( robotIsOutOfBounds maxCoords newPosition, Set.member robotCoords scents ) of
                ( True, True ) ->
                    -- This move would put us out of bounds but there's a scent, so we ignore
                    -- the move and recurse with our old state
                    followInstructions maxCoords scents robotState restInstructions

                ( True, False ) ->
                    -- Our robot is now lost :(
                    Lost position

                ( False, _ ) ->
                    -- This move doesn't put us out of bounds, so we continue to recurse.
                    followInstructions maxCoords scents (KnownPosition newPosition) restInstructions
