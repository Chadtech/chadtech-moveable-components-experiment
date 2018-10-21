module Main exposing (init, main, subscriptions, update)

import Body
import Browser
import Browser.Events
import Css exposing (..)
import Db exposing (Db)
import Error exposing (Error)
import Flags
import Header
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Json.Decode as D
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports exposing (JsMsg)
import Return2 as R2
import Session
import Style
import Window



-- MAIN --


main : Program D.Value (Result Error Model) Msg
main =
    { init = init
    , view = view
    , update = updateOk
    , subscriptions =
        Result.map subscriptions
            >> Result.withDefault Sub.none
    }
        |> Browser.document


updateOk : Msg -> Result Error Model -> ( Result Error Model, Cmd Msg )
updateOk msg result =
    case result of
        Ok model ->
            update msg model
                |> Tuple.mapFirst Ok

        Err err ->
            Err err
                |> R2.withNoCmd



-- INIT --


init : D.Value -> ( Result Error Model, Cmd Msg )
init json =
    json
        |> D.decodeValue Flags.decoder
        |> Result.map Model.fromFlags
        |> Result.mapError Error.fromFlagsDecode
        |> R2.withNoCmd



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Ports.fromJs Msg.decode
    , Browser.Events.onResize WindowResized
    , Sub.map BodyMsg (Body.subscriptions model)
    ]
        |> Sub.batch



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeaderMsg subMsg ->
            Header.update subMsg model
                |> R2.withNoCmd

        BodyMsg subMsg ->
            Body.update subMsg model
                |> R2.withNoCmd

        WindowResized width height ->
            Model.mapSession
                (Session.setWindowSize width height)
                model
                |> R2.withNoCmd

        MsgDecodeFailed _ ->
            model
                |> R2.withNoCmd



-- VIEW --


view : Result Error Model -> Browser.Document Msg
view result =
    case result of
        Ok model ->
            { title = "Chadtech"
            , body =
                [ Style.globals
                , Grid.row
                    []
                    [ Grid.column
                        []
                        [ model
                            |> Header.view
                            |> Html.map HeaderMsg
                        ]
                    ]
                , Grid.row
                    [ flex (int 1) ]
                    [ Grid.column
                        []
                        [ Body.view model
                            |> Html.map BodyMsg
                        ]
                    ]
                ]
                    |> List.map Html.toUnstyled
            }

        Err error ->
            Error.view error
