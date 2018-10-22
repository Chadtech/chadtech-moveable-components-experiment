port module Ports exposing
    ( JsMsg(..)
    , fromJs
    , send
    )

import Json.Encode as E exposing (Value)


type JsMsg
    = SaveModel E.Value


toCmd : String -> Value -> Cmd msg
toCmd type_ payload =
    [ ( "type", E.string type_ )
    , ( "payload", payload )
    ]
        |> E.object
        |> toJs


noPayload : String -> Cmd msg
noPayload type_ =
    toCmd type_ E.null


send : JsMsg -> Cmd msg
send msg =
    case msg of
        SaveModel modelJson ->
            toCmd "saveModel" modelJson


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
