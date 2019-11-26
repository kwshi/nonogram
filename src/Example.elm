module Example exposing (..)

import Color exposing (Color, colors)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Nonogram exposing (Block, Nonogram, block)


type alias Literal =
    Int -> Block


make : Color.Color -> Literal
make c n =
    Nonogram.block n c


k : Literal
k =
    make colors.k


g : Literal
g =
    make colors.g


r : Literal
r =
    make colors.r


y : Literal
y =
    make colors.y


type alias Example =
    { name : String
    , source : String
    , nonogram : Nonogram
    }


examples : List Example
examples =
    [ Example
        "apple"
        "https://en.grandgames.net/nonograms/picross/yabloko_26"
      <|
        Nonogram
            [ [ g 4 ]
            , [ g 5 ]
            , [ g 6, k 1 ]
            , [ g 6, k 2 ]
            , [ r 3, g 1, k 2, r 3 ]
            , [ r 1, r 1, k 1, r 1, r 1 ]
            , [ r 2, r 1, r 2 ]
            , [ r 1, y 2, y 2, r 1 ]
            , [ r 1, y 1, k 1, k 1, y 1, r 1 ]
            , [ r 1, y 1, k 1, k 1, y 1, r 1 ]
            , [ r 2, y 2, y 2, r 2 ]
            , [ r 1, r 1 ]
            , [ r 2, r 2 ]
            , [ r 2, k 1, r 2 ]
            , [ r 3, r 3 ]
            ]
            [ [ g 1 ]
            , [ g 3, r 5 ]
            , [ g 4, r 2, r 3 ]
            , [ g 4, r 1, r 2 ]
            , [ g 3, r 1, r 2 ]
            , [ g 3, r 1, y 4, r 1 ]
            , [ g 3, r 1, y 1, k 2, y 1, r 1 ]
            , [ g 1, k 2, r 1, k 1 ]
            , [ k 2, r 1, y 1, k 2, y 1, r 1 ]
            , [ k 2, r 1, y 4, r 1 ]
            , [ r 1, r 2 ]
            , [ r 1, r 2 ]
            , [ r 2, r 3 ]
            , [ r 5 ]
            ]

    --Example "parrot"
      --  "https://en.grandgames.net/nonograms/picross/popugay_parrot"
      --      <|
      --          Nonogram
      --              [[ k 1, n 6 ]
      --              , [ k 5, g 4, n 10]
      --              , [g 1, k 1, g 2, k 3, g 6, n 5, e 3, n 3, e 2]
      --              , [g 1, k 3, g, 6, n 2, r 2, y 2, e 2, k 1, e 2, n 1, e 1, k 2, e 1],
      --              , [g 2, k 1, g 3, n 2, r 2, y 2, k 1, e 3, e 1, k 4, e 1]
      --              , []
    ]

format : Example -> String
format {source, nonogram} =
    "# " ++ source ++ "\n" ++ Nonogram.format nonogram



view : Html Example
view =
    div
        [ id "examples" ]
        [ h2 [] [ text "Examples" ]
        , div []
            (examples
                |> List.map
                    (\ex ->
                        button
                         [ onClick ex ]
                            [ text ex.name ]
                    )
            )
        ]
