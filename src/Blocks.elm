module Blocks exposing (..)

import Array
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr


type Msg
    = Nop


type alias Model =
    { blocks : Array.Array Block
    }


type alias Block =
    { count : Int
    , color : Char
    }


empty : Model
empty =
    { blocks =
        Array.fromList
            [ { count = 3, color = 'r' }
            , { count = 2, color = 'k' }
            , { count = 4, color = 'g' }
            , { count = 1, color = 'y' }
            ]
    }


color : Char -> ( Int, Int, Int )
color c =
    case c of
        'r' ->
            ( 255, 0, 0 )

        'g' ->
            ( 0, 255, 0 )

        'b' ->
            ( 0, 0, 255 )

        'k' ->
            ( 0, 0, 0 )

        'y' ->
            ( 255, 255, 0 )

        _ ->
            ( 255, 255, 255 )


view : Model -> Html.Html Msg
view {blocks} =
    Html.div
        []
        (blocks
            |> Array.indexedMap
                (\i block ->
                    Html.span
                        [ Attr.css
                            [ Css.backgroundColor
                                (let
                                    ( r, g, b ) =
                                        color block.color
                                 in
                                 Css.rgb r g b
                                )
                            ]
                        ]
                        [ Html.text (String.fromInt block.count)
                        ]
                )
            |> Array.toList
        )
