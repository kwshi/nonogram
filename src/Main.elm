module Main exposing (main)

import Browser
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Nonogram


main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    { controls :
        { constraints :
            { rows : String
            , cols : String
            }
        }
    , grid : {}
    , nonogram : Nonogram.Nonogram
    }


type Msg
    = Nop
    | RowsInput String
    | ColsInput String


init : () -> ( Model, Cmd Msg )
init () =
    ( { controls =
            { constraints =
                { rows = ""
                , cols = ""
                }
            }
      , grid = {}
      , nonogram = Nonogram.init
      }
    , Cmd.none
    )


subscriptions _ =
    Sub.none


setRowsOf constraints s =
    { constraints | rows = s }


setColsOf constraints s =
    { constraints | cols = s }


setConstraintsOf controls c =
    { controls | constraints = c }


setControlsOf model c =
    { model | controls = c }


setNonogramOf model n =
    { model | nonogram = n }


update msg model =
    let
        _ =
            Debug.log "msg" msg
    in
    case msg of
        RowsInput s ->
            ( Nonogram.parse s model.controls.constraints.cols
                |> Maybe.map
                    (\n ->
                        s
                            |> setRowsOf model.controls.constraints
                            |> setConstraintsOf model.controls
                            |> setControlsOf model
                    )
                |> Maybe.default s
            , Cmd.none
            )

        ColsInput s ->
            ( s
                |> setColsOf model.controls.constraints
                |> setConstraintsOf model.controls
                |> setControlsOf model
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


view model =
    { title = ""
    , body =
        [ viewBody model |> Html.toUnstyled ]
    }


viewBody model =
    Html.div
        [ Attr.css
            [ Css.position Css.absolute
            , Css.left <| Css.px 0
            , Css.top <| Css.px 0
            , Css.right <| Css.px 0
            , Css.bottom <| Css.px 0
            , Css.displayFlex
            ]
        ]
        [ viewControls model.controls
        , viewGrid model.grid
        ]


viewControls controls =
    Html.div
        [ Attr.css
            [ Css.borderRight3 (Css.px 1) Css.solid (Css.rgb 0 0 0)
            , Css.padding2 (Css.em 1) (Css.em 2)
            , Css.minWidth (Css.em 20)
            , Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]
        [ viewInput "Row" RowsInput controls.constraints.rows
        , viewInput "Column" ColsInput controls.constraints.cols
        ]


viewInput label onInput input =
    Html.div
        [ Attr.css
            [ Css.padding2 (Css.em 0.5) (Css.em 0)
            , Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]
        [ Html.div [] [ Html.text <| label ++ " constraints" ]
        , Html.textarea
            [ Events.onInput onInput
            , Attr.value input
            , Attr.css
                [ Css.resize Css.none
                , Css.height <| Css.em 20
                , Css.padding <| Css.em 0.5
                ]
            ]
            []
        ]


viewGrid grid =
    Html.div
        [ Attr.css
            [ Css.flexGrow <| Css.num 1 ]
        ]
        []
