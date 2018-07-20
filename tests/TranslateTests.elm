module TranslateTests exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Translate exposing (..)


unitTests : Test
unitTests =
    describe "Translate"
        [ describe "toJava"
            [ test "adds double quote around the SQL expression" <|
                let
                    expected =
                        "\" SELECT * FROM Cats \""

                    actual =
                        toJava "SELECT * FROM Cats"
                in
                    \_ -> Expect.equal expected actual
            , test "preserves whitespace on the left" <|
                let
                    expected =
                        "\"  \t  SELECT * FROM Cats \""

                    actual =
                        toJava " \t  SELECT * FROM Cats"
                in
                    \_ -> Expect.equal expected actual
            , test "removes whitespace on the right" <|
                let
                    expected =
                        "\"   SELECT * FROM Cats \""

                    actual =
                        toJava "  SELECT * FROM Cats               "
                in
                    \_ -> Expect.equal expected actual
            ]
        , describe "toJavaLines"
            [ test "adds a semicolon at the end" <|
                let
                    expected =
                        "\"  \";"

                    actual =
                        toJavaLines ""
                in
                    \_ -> Expect.equal expected actual
            , test "translates a single line" <|
                let
                    expected =
                        "\" SELECT * FROM Cats \";"

                    actual =
                        toJavaLines "SELECT * FROM Cats"
                in
                    \_ -> Expect.equal expected actual
            , test "translates two lines" <|
                let
                    expected =
                        "\" SELECT * \"\n+ \" FROM Cats \";"

                    actual =
                        toJavaLines "SELECT *\nFROM Cats"
                in
                    \_ -> Expect.equal expected actual
            ]
        , describe "toSQL"
            [ test "edge case" <|
                let
                    expected =
                        "a"

                    actual =
                        toSQL "\" a \""
                in
                    \_ -> Expect.equal expected actual
            , test "keeps whitespace on the left" <|
                let
                    expected =
                        "      SELECT * FROM Cats"

                    actual =
                        toSQL "\"       SELECT * FROM Cats \""
                in
                    \_ -> Expect.equal expected actual
            , test "removes whitespace on the right" <|
                let
                    expected =
                        "SELECT * FROM Cats"

                    actual =
                        toSQL "\" SELECT * FROM Cats                    \""
                in
                    \_ -> Expect.equal expected actual
            , test "removes extraneous characters" <|
                let
                    expected =
                        "SELECT * FROM Cats"

                    actual =
                        toSQL "+ \" SELECT * FROM Cats \";"
                in
                    \_ -> Expect.equal expected actual
            , test "keeps parentheses" <|
                let
                    expected =
                        "(a, b, c)"

                    actual =
                        toSQL "(a, b, c)"
                in
                    \_ -> Expect.equal expected actual
            , test "keeps brackets" <|
                let
                    expected =
                        "[a, b, c]"

                    actual =
                        toSQL "[a, b, c]"
                in
                    \_ -> Expect.equal expected actual
            ]
        , describe "toSQLLines"
            [ test "translates a single line" <|
                let
                    expected =
                        "SELECT * FROM Cats"

                    actual =
                        toSQLLines "+ \" SELECT * FROM Cats \";"
                in
                    \_ -> Expect.equal expected actual
            , test "translates two lines" <|
                let
                    expected =
                        "SELECT *\nFROM Cats"

                    actual =
                        toSQLLines "\"SELECT *\"\n+ \" FROM Cats \";"
                in
                    \_ -> Expect.equal expected actual
            ]
        ]
