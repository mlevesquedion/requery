module Main exposing (..)

import Html
import Types exposing (..)
import View exposing (view)
import Translate exposing (toJavaLines, toSQLLines)


init : Model
init =
    Model "" "\" \";"


minusPrefix : String -> String
minusPrefix =
    String.dropLeft 20


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewSQL newSQL ->
            { model | sql = newSQL, java = toJavaLines newSQL }

        NewJava newJava ->
            { model | java = (minusPrefix newJava), sql = toSQLLines (minusPrefix newJava) }

        NoOp ->
            model


main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }
