module Translate exposing (..)

import Regex exposing (..)


quote : String
quote =
    "\""


wrapInQuotes : String -> String
wrapInQuotes s =
    quote ++ " " ++ s ++ " " ++ quote


toJava : String -> String
toJava =
    wrapInQuotes << String.trimRight


translateLines : (String -> String) -> String -> String -> (String -> String)
translateLines transform joiner suffix =
    String.split "\n"
        >> List.map transform
        >> String.join joiner
        >> (flip (++)) suffix


toJavaLines : String -> String
toJavaLines =
    translateLines toJava "\n+ " ";"


sqlInJava : Regex
sqlInJava =
    regex "( ?)( *)(\\w.*[\\w\\*]|\\w)"


toSQL : String -> String
toSQL java =
    let
        matches =
            find (AtMost 1) sqlInJava java
    in
        case matches of
            head :: tail ->
                let
                    groups =
                        .submatches head

                    withoutLeadingSpace =
                        List.drop 1 groups

                    withoutMaybes =
                        List.filterMap identity withoutLeadingSpace
                in
                    case withoutMaybes of
                        [] ->
                            ""

                        head :: tail ->
                            String.join "" withoutMaybes

            [] ->
                ""


toSQLLines : String -> String
toSQLLines =
    translateLines toSQL "\n" ""
