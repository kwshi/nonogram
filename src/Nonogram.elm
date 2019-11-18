module Nonogram exposing (Nonogram, init, parse)


type alias Grp =
    List ( Int, Char )


type alias Nonogram =
    { grps :
        { rows : List Grp
        , cols : List Grp
        }
    }


init : Nonogram
init =
    { grps =
        { rows = []
        , cols = []
        }
    }


parsePair : String -> Maybe ( Int, Char )
parsePair s =
    let
        flipDecode ( clr, ns ) =
            ns
                |> String.toInt
                |> Maybe.map (\n -> ( n, clr ))
    in
    s
        |> String.reverse
        |> String.uncons
        |> Maybe.andThen flipDecode


justAll : List (Maybe a) -> Maybe (List a)
justAll =
    List.foldr
        (Maybe.map2 (\a l -> a :: l))
        (Just [])


parseGrp : String -> Maybe Grp
parseGrp =
    String.trim
        >> String.words
        >> List.map parsePair
        >> justAll


parseGrps : String -> Maybe (List Grp)
parseGrps =
    String.trim
        >> String.lines
        >> List.map parseGrp
        >> justAll


parse : String -> String -> Maybe Nonogram
parse rows cols =
    let
        p r c =
            { grps =
                { rows = r
                , cols = c
                }
            }
    in
    Maybe.map2 p (parseGrps rows) (parseGrps cols)
