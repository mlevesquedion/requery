module View exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, value)
import Html.Styled.Events exposing (onInput)
import Css exposing (..)
import Css.Transitions exposing (transition, easeInOut)
import Types exposing (..)


headerFont : Style
headerFont =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , fontSize (Css.em 2)
        , fontWeight bolder
        ]


paragraphFont : Style
paragraphFont =
    Css.batch
        [ fontFamilies [ "Roboto Mono", "monospace" ]
        , fontSize (Css.em 1)
        , fontWeight normal
        ]


type alias Fonts =
    { header : Style
    , paragraph : Style
    }


fonts : Fonts
fonts =
    { header = headerFont
    , paragraph = paragraphFont
    }


sqlBlue : Color
sqlBlue =
    rgb 33 108 192


javaRed : Color
javaRed =
    rgb 217 0 23


type alias Colors =
    { primary : Color
    , secondary : Color
    , tertiary : Color
    , sql : Color
    , java : Color
    }


colors : Colors
colors =
    { primary = rgb 61 52 139
    , secondary = rgb 118 120 237
    , tertiary = rgb 241 135 1
    , sql = rgb 247 184 1
    , java = rgb 243 91 4
    }


twoColumnWrapper : List (Html msg) -> Html msg
twoColumnWrapper =
    div
        [ css
            [ displayFlex
            , backgroundColor colors.secondary
            , minHeight (pct 100)
            ]
        ]


halfPageDiv : List (Html msg) -> Html msg
halfPageDiv =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , alignItems center
            , width (pct 50)
            , height (pct 100)
            , minHeight (pct 100)
            , flex (num 1)
            ]
        ]


largeTextArea : Color -> String -> (String -> Msg) -> Html Msg
largeTextArea borderColor val message =
    textarea
        [ value val
        , onInput message
        , css
            [ width (pct 90)
            , height (px 700)
            , minHeight (px 700)
            , paragraphFont
            , flex (num 1)
            , resize none
            , border3 (px 5) solid borderColor
            , marginTop (px 5)
            , focus
                [ border3 (px 10) solid colors.tertiary
                , marginTop (px 0)
                , outline none
                ]
            , transition
                [ Css.Transitions.border3 200 0 easeInOut
                , Css.Transitions.marginTop3 200 0 easeInOut
                ]
            ]
        ]
        []


columnHeader : Color -> List (Html msg) -> Html msg
columnHeader c =
    h2
        [ css [ color c, headerFont ]
        ]


pageHeader : List (Html msg) -> Html msg
pageHeader =
    h1 [ css [ headerFont, color colors.primary, marginLeft (pct 2) ] ]


pageWrapper : List (Html msg) -> Html msg
pageWrapper =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , height (vh 100)
            ]
        ]


withPrefix : String -> String
withPrefix =
    (++) "String query = \"\"\n+ "


styledView : Model -> Html Msg
styledView model =
    pageWrapper
        [ pageHeader [ text "requery" ]
        , twoColumnWrapper
            [ halfPageDiv
                [ columnHeader colors.sql [ text "SQL" ]
                , largeTextArea colors.sql model.sql NewSQL
                ]
            , halfPageDiv
                [ columnHeader colors.java [ text "Java" ]
                , largeTextArea colors.java (withPrefix model.java) NewJava
                ]
            ]
        ]


view =
    styledView >> toUnstyled
