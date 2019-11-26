module Color exposing (Color, default, colors, format, get, viewKey, cssColor)

import Css exposing (..)
import Dict exposing (Dict)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)


type alias ColorData =
    { key : Char
    , name : String
    , r : Int
    , g : Int
    , b : Int
    }


type Color
    = Color ColorData


type alias Colors =
    { k : Color
    , g : Color
    , r : Color
    , b : Color
    , y : Color
    , o : Color
    , e : Color
    , v : Color
    , p : Color
    , i : Color
    , n : Color
    , q : Color
    }


colors : Colors
colors =
    { k = Color <| ColorData 'k' "black" 70 60 50
    , g = Color <| ColorData 'g' "green" 80 190 40
    , r = Color <| ColorData 'r' "red" 230 60 40
    , b = Color <| ColorData 'b' "blue" 40 160 240
    , y = Color <| ColorData 'y' "yellow" 230 180 30
    , o = Color <| ColorData 'o' "orange" 230 120 30
    , e = Color <| ColorData 'e' "grey" 170 160 140
    , v = Color <| ColorData 'v' "violet" 150 60 220
    , p = Color <| ColorData 'p' "purple" 220 70 230
    , i = Color <| ColorData 'i' "indigo" 30 100 150
    , n = Color <| ColorData 'n' "brown" 140 80 0
    , q = Color <| ColorData 'q' "aqua" 60 180 190
    }

default : Color
default = colors.k


colorList : List Color
colorList =
    [ colors.k
    , colors.g
    , colors.r
    , colors.b
    , colors.y
    , colors.o
    , colors.e
    , colors.v
    , colors.p
    , colors.i
    , colors.n
    , colors.q
    ]


colorKey : Dict Char Color
colorKey =
    colorList
        |> List.map (\(Color c) -> ( c.key, Color c ))
        |> Dict.fromList


format : Color -> Char
format (Color { key }) =
    key


get : Char -> Maybe Color
get k =
    Dict.get k colorKey

cssColor : Color -> Css.Color
cssColor (Color {r, g, b}) =
    rgb r g b


viewKey : Html a
viewKey =
    div
        [ id "color-key" ]
        [ h2 [] [ text "Colors" ]
        , div
            [ css [ displayFlex ] ]
            (colorList
                |> List.map
                    (\(Color { key, r, g, b }) ->
                        div
                            [ css
                                [ backgroundColor <| rgb r g b
                                , padding <| rem 0.25
                                , Css.width <| rem 1
                                , Css.height <| rem 1
                                , displayFlex
                                , justifyContent center
                                , alignItems center
                                , color <| rgb 255 255 255
                                , marginRight <| rem 0.5
                                ]
                            ]
                            [ text <| String.fromChar key ]
                    )
            )
        ]
