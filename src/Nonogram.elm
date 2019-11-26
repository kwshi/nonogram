module Nonogram exposing (..)

import Color exposing (Color)
import Parser exposing (..)


type alias Block =
    { count : Int
    , color : Color
    }


type alias Nonogram =
    { rows : List (List Block)
    , cols : List (List Block)
    }


block : Int -> Color -> Block
block =
    Block


nonogram : List (List Block) -> List (List Block) -> Nonogram
nonogram =
    Nonogram


formatBlocks : List (List Block) -> String
formatBlocks =
    List.map
        (List.map
            (\{ count, color } ->
                String.fromInt count
                    ++ String.fromChar (Color.format color)
            )
            >> String.join " "
        )
        >> String.join "\n"


format : Nonogram -> String
format { rows, cols } =
    formatBlocks rows ++ "\n/\n" ++ formatBlocks cols


blockParser : Parser Block
blockParser =
    succeed Block
        |= (chompWhile Char.isDigit
                |> getChompedString
                |> andThen
                    (\s ->
                        case String.toInt s of
                            Just n ->
                                succeed n

                            Nothing ->
                                problem "expect int"
                    )
           )
        |= (chompWhile Char.isAlpha
                |> getChompedString
                |> andThen
                    (\s ->
                        case String.uncons s of
                            Nothing ->
                                succeed Color.default

                            Just ( c, "" ) ->
                                Color.get c
                                    |> Maybe.map succeed
                                    |> Maybe.withDefault (problem "unrecognized color")

                            _ ->
                                problem "too many characters"
                    )
           )


lineParser : Parser (List Block)
lineParser =
    sequence
        { start = ""
        , end = ""
        , separator = " "
        , item = blockParser
        , spaces = succeed ()
        , trailing = Optional
        }
        |. chompWhile ((==) ' ')


blocksParser : Trailing -> Parser (List (List Block))
blocksParser trailing =
    sequence
        { start = ""
        , end = ""
        , separator = "\n"
        , item = lineParser
        , spaces = succeed ()
        , trailing = trailing
        }


parser : Parser Nonogram
parser =
    succeed Nonogram
        |. loop ()
            (always <|
                oneOf
                    [ lineComment "#" |. chompIf ((==) '\n') |> map Loop
                    , succeed () |> map Done
                    ]
            )
        |= blocksParser Mandatory
        |. symbol "/"
        |. chompWhile ((==) ' ')
        |. token "\n"
        |= blocksParser Forbidden
