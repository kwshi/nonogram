module Main exposing (main)

import Array exposing (Array)
import Browser
import Browser.Events
import Color
import Css exposing (..)
import Dict exposing (Dict)
import Example exposing (Example)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Html.Styled.Events as Events exposing (..)
import Json.Decode as Json
import Nonogram exposing (Nonogram)
import Parser exposing ((|.), (|=))
import Theme


type alias Model =
    { nonogram : Nonogram
    , input : String
    , error : List Parser.DeadEnd
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { nonogram =
            { rows = []
            , cols = []
            }
      , input = ""
      , error = []
      }
    , Cmd.none
    )


setNonogram : Nonogram -> Model -> Model
setNonogram nonogram model =
    { model | nonogram = nonogram }


type Msg
    = Nop
    | Input String
    | Example Example



--parser : Parser.Parser Blocks
--parser =
--    let
--        p =
--            Parser.sequence
--                { start = ""
--                , separator = ","
--                , end = ""
--                , spaces = Parser.spaces
--                , item =
--                    Parser.sequence
--                        { start = ""
--                        , separator = ""
--                        , end = ""
--                        , spaces = Parser.spaces
--                        , item =
--                            Parser.succeed Block
--                                |= (Parser.chompWhile Char.isDigit
--                                        |> Parser.getChompedString
--                                        |> Parser.andThen
--                                            (String.toInt
--                                                >> Maybe.map Parser.succeed
--                                                >> Maybe.withDefault
--                                                    (Parser.problem "expecting integer")
--                                            )
--                                   )
--                                |. Parser.spaces
--                                |= (Parser.chompIf Char.isAlpha
--                                        |> Parser.getChompedString
--                                        |> Parser.andThen
--                                            (String.uncons
--                                                >> Maybe.map (Tuple.first >> Parser.succeed)
--                                                >> Maybe.withDefault
--                                                    (Parser.problem "expecting char")
--                                            )
--                                   )
--                        , trailing = Parser.Forbidden
--                        }
--                , trailing = Parser.Forbidden
--                }
--    in
--    Parser.succeed Blocks
--        |= p
--        |= Parser.oneOf
--            [ Parser.succeed identity
--                |. Parser.symbol ";"
--                |= p
--            , Parser.succeed []
--            ]
--        |. Parser.end


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg

        _ =
            Debug.log "model" model
    in
    case msg of
        Input s ->
            let
                ( nonogram, error ) =
                    case Parser.run Nonogram.parser s of
                        Ok bs ->
                            ( bs, [] )

                        Err e ->
                            ( model.nonogram, e )
            in
            ( { model
                | nonogram = nonogram
                , error = error
                , input = s
              }
            , Cmd.none
            )

        Example e ->
            ( { model
                | input = Example.format e
                , nonogram = e.nonogram
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    main_
        [ css Theme.root ]
        [ div
            [ id "sidebar"
            , css Theme.sidebar
            ]
            [ h1 [ css Theme.title ] [ text "Nonogram" ]
            , textarea
                [ id "input"
                , placeholder "Enter nonogram here..."
                , css Theme.input
                , onInput Input
                , value model.input
                ]
                []
            , div
                [ id "info"
                , css Theme.info
                ]
                (model.error
                    |> List.map
                        (\e ->
                            p
                                [ class "parse-error" ]
                                [ span [ class "row" ] [ text <| String.fromInt e.row ]
                                , text ", "
                                , span [ class "col" ] [ text <| String.fromInt e.col ]
                                , text ": "
                                , span [ class "error" ]
                                    [ text <|
                                        case e.problem of
                                            Parser.Expecting s ->
                                                "expecting " ++ s

                                            Parser.UnexpectedChar ->
                                                "unexpected char"

                                            Parser.ExpectingEnd ->
                                                "expecting end of input"

                                            _ ->
                                                ""
                                    ]
                                ]
                        )
                )
            , Example.view |> Html.map Example
            , Color.viewKey
            ]
        , div
            [ id "content"
            , css
                [ flexGrow <| num 1
                , displayFlex
                , alignItems center
                , justifyContent center
                , paddingBottom <| rem 4
                ]
            ]
            [ let
                maxWidth dir =
                    dir model.nonogram
                        |> List.map List.length
                        |> List.maximum
                        |> Maybe.withDefault 0

                rowsWidth =
                    maxWidth .rows

                colsWidth =
                    maxWidth .cols
              in
              div
                [ id "grid"
                , css
                    (let
                        gridTemplate dir width =
                            "repeat("
                                ++ (List.length (dir model.nonogram)
                                        + width
                                        |> String.fromInt
                                   )
                                ++ ", 1.5rem)"
                     in
                     [ Css.property "display" "grid"
                     , Css.property "grid-template-rows" <|
                        gridTemplate .rows colsWidth
                     , Css.property "grid-template-columns" <|
                        gridTemplate .cols rowsWidth
                     , color <| rgb 255 255 255
                     ]
                    )
                ]
                (let
                    viewBlocks alongName perpName width perpWidth dir =
                        dir model.nonogram
                            |> List.indexedMap
                                (\i blocks ->
                                    let
                                        w =
                                            List.length blocks
                                    in
                                    blocks
                                        |> List.indexedMap
                                            (\j block ->
                                                div
                                                    [ css
                                                        [ backgroundColor <| Color.cssColor block.color
                                                        , displayFlex
                                                        , alignItems center
                                                        , justifyContent center
                                                        , Css.property ("grid-" ++ alongName ++ "-start") <|
                                                            String.fromInt (perpWidth + i + 1)
                                                        , Css.property ("grid-" ++ perpName ++ "-start") <|
                                                            String.fromInt (width - w + j + 1)
                                                        , overflow Css.hidden
                                                        ]
                                                    ]
                                                    [ text <| String.fromInt block.count ]
                                            )
                                )
                            |> List.concat
                 in
                 div
                    [ css
                        [ borderStyle solid
                        , borderColor <| rgb 230 230 230
                        , borderWidth4 (px 1) (px 0) (px 0) (px 1)
                        , Css.property "grid-row-start" <|
                            String.fromInt (colsWidth + 1)
                        , Css.property "grid-column-start" <|
                            String.fromInt (rowsWidth + 1)
                        , Css.property "grid-row-end" "-1"
                        , Css.property "grid-column-end" "-1"
                        ]
                    ]
                    []
                    :: viewBlocks "row" "column" rowsWidth colsWidth .rows
                    ++ viewBlocks "column" "row" colsWidth rowsWidth .cols
                    ++ (List.range 1 (List.length model.nonogram.rows)
                            |> List.map
                                (\r ->
                                    List.range 1 (List.length model.nonogram.cols)
                                        |> List.map
                                            (\c ->
                                                div
                                                    [ css
                                                        [ borderStyle solid
                                                        , borderColor <| rgb 230 230 230
                                                        , borderWidth4 (px 0) (px 1) (px 1) (px 0)
                                                        , Css.property "grid-row-start" <|
                                                            String.fromInt (colsWidth + r)
                                                        , Css.property "grid-column-start" <|
                                                            String.fromInt (rowsWidth + c)
                                                        ]
                                                    ]
                                                    []
                                            )
                                )
                            |> List.concat
                       )
                )
            ]
        ]
        |> Html.toUnstyled
        |> List.singleton
        |> Browser.Document "Nonogram"


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
