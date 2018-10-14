module Main exposing (init, main, subscriptions, update)

import Browser
import Html.Styled
import Json.Decode as D
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports exposing (JsMsg)
import Return2 as R2
import View exposing (view)



-- MAIN --


main : Program D.Value Model Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
        |> Browser.document


init : D.Value -> ( Model, Cmd Msg )
init json =
    {}
        |> R2.withNoCmd



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Ports.fromJs Msg.decode



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgDecodeFailed _ ->
            model
                |> R2.withNoCmd
