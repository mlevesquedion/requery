module MainTests exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Main exposing (..)
import Types exposing (..)


suite : Test
suite =
    describe "Main"
        [ describe "update"
            [ test "when NewSQL, should update SQL and translate to Java" <|
                let
                    expected =
                        { init | sql = "a", java = "\" a \";" }

                    actual =
                        update (NewSQL "a") init
                in
                    \_ -> Expect.equal expected actual
            , test "when NewJava, should update Java and translate to SQL" <|
                let
                    expected =
                        { init | java = "\" a \";", sql = "a" }

                    actual =
                        update (NewJava "\" a \";") init
                in
                    \_ -> Expect.equal expected actual
            ]
        ]
