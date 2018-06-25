module Types exposing (..)


type alias SQL =
    String


type alias Java =
    String


type alias Model =
    { sql : SQL
    , java : Java
    }


type Msg
    = NewSQL SQL
    | NewJava Java
    | NoOp
