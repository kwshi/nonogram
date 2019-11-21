module Nonogram exposing (Nonogram, empty, parrot, view)

import Char
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import List.Extra as List
import Parser exposing ((|.), (|=))


type Color
    = Color Char


type Block
    = Block { count : Int, color : Color }


type Nonogram
    = Nonogram
        { rows : List (List Block)
        , cols : List (List Block)
        }


block : Int -> Color -> Block
block count clr =
    Block { count = count, color = clr }


color : Char -> Color
color =
    Color


empty : Nonogram
empty =
    Nonogram
        { rows = []
        , cols = []
        }


parrot : Nonogram
parrot =
    Nonogram
        { rows =
            [ [ block 4 (color 'c') ]
            ]
        , cols = []
        }

apple : Nonogram
apple =
    Nonogram
        { rows =
              [ [ block 4 (color 'g')]
              , [block 5 (color 'g')]
              , [block 6 (color 'g'), block 1 (color 'k')]
              , [block 6 (color 'g'), block 2 (color 'k')]
              , [block 3 (color 'r'), block 1 (color 'g'), block 2 (color 'k'), block 3 (color 'r')]
              , []
              ]
              , cols =
              []
        }


view : Nonogram -> Html.Html a
view (Nonogram { rows, cols }) =
    Html.table
        []
        (rows
            |> List.map
                (\row ->
                    Html.tr
                        []
                        [ Html.th []
                            (row
                                |> List.map
                                    (\(Block { count }) -> Html.text (String.fromInt count))
                            )
                        ]
                )
        )



--parseColor : String -> Maybe Color
--parseColor s =
--    case String.toList s of
--        [ c ] ->
--            Just (Color c)
--
--        _ ->
--            Nothing
--
--
--parseBlock : String -> Maybe Block
--parseBlock s =
--    let
--        ( countStr, colorStr ) =
--            String.toList s
--                |> List.span Char.isDigit
--    in
--    Maybe.map2
--        (\ct clr -> Block { count = ct, color = clr })
--        (String.fromList countStr |> String.toInt)
--        (String.fromList colorStr |> parseColor)
--spaces : Parser.Parser ()
--spaces =
--    Parser.loop ()
--        (\() ->
--            Parser.oneOf
--                [ Parser.succeed (Parser.Loop ())
--                    |. Parser.symbol " "
--                , Parser.succeed (Parser.Done ())
--                ]
--        )
--
--
--int : Parser.Parser Int
--int =
--    Parser.chompWhile Char.isDigit
--        |> Parser.getChompedString
--        |> Parser.andThen
--            (\s ->
--                case String.toInt s of
--                    Just n ->
--                        Parser.succeed n
--
--                    Nothing ->
--                        Parser.problem "expecting integer"
--            )
--
--
--block : Parser.Parser Block
--block =
--    Parser.succeed Block
--        |= int
--        |. Parser.spaces
--        |= (Parser.chompIf Char.isAlpha
--                |> Parser.getChompedString
--                |> Parser.andThen
--                    (\s ->
--                        case String.uncons s of
--                            Just ( c, _ ) ->
--                                Parser.succeed (Color c)
--
--                            Nothing ->
--                                Parser.problem "expecting a letter"
--                    )
--           )
--
--
--blocks : Parser.Parser (List Block)
--blocks =
--    Parser.loop
--        []
--        (\bs ->
--            Parser.oneOf
--                [ Parser.succeed (\b -> Parser.Loop (b :: bs))
--                    |= block
--                    |. spaces
--                , Parser.succeed ()
--                    |> Parser.map (\() -> Parser.Done (List.reverse bs))
--                ]
--        )
--
--
--series : Parser.Parser (List (List Block))
--series =
--    Parser.sequence
--        { start = ""
--        , separator = "\n"
--        , end = ""
--        , spaces = spaces
--        , item = blocks
--        , trailing = Parser.Forbidden
--        }
--
--
--
----parser : Parser.Parser (Nonogram)
----parser =
----    Parser.succeed Nonogram
----        |= blocks
