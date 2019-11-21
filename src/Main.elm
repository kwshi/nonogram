module Main exposing (main)

--import Blocks
import Browser
import Browser.Events
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Json


type alias Model =
    {
    }


init () =
    ( {
      }
    , Cmd.none
    )


type Msg
    = Nop
    | Key String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Key key -> let _ = Debug.log "key" key in (model, Cmd.none)
        Nop ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    Html.div
        [ Attr.id "main" ]
        [ Html.div
              []
              [ Blocks.view model.blocks |> Html.map (always Nop) ]
        ]
        |> Html.toUnstyled
        |> List.singleton
        |> Browser.Document "title"

subscriptions : Model -> Sub Msg
subscriptions _ =
    Json.field "key" Json.string
        |> Json.map Key
        |> Browser.Events.onKeyDown

main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
