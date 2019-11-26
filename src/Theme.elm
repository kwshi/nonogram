module Theme exposing (..)

import Css exposing (..)


type alias Style =
    List Css.Style


root : Style
root =
    [ position absolute
    , top <| px 0
    , bottom <| px 0
    , left <| px 0
    , right <| px 0
    , displayFlex
    , fontFamilies [ "IBM Plex Mono" ]
    , fontSize <| rem 0.875
    ]


sidebar : Style
sidebar =
    [ backgroundColor <| rgb 240 240 240
    , displayFlex
    , flexDirection column
    , padding2 (rem 1) (rem 1)
    , minWidth <| rem 30
    ]


title : Style
title =
    [ marginBottom <| rem 1
    , marginTop <| rem 0
    , fontWeight <| int 300
    , fontSize <| rem 2
    ]


input : Style
input =
    [ resize none
    , flexGrow <| num 1
    , fontSize inherit
    , fontFamily inherit
    ]


info : Style
info =
    [ Css.height <| rem 2
    , lineHeight <| rem 0
    , marginBottom <| rem 1
    , textAlign right
    ]
