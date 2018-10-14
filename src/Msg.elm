module Msg exposing
    ( Msg(..)
    , decode
    )

import Json.Decode as D exposing (Decoder, Value)


type Msg
    = MsgDecodeFailed D.Error


decode : Value -> Msg
decode json =
    case D.decodeValue decoder json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed err


decoder : Decoder Msg
decoder =
    D.string
        |> D.field "type"
        |> D.andThen
            (D.field "payload" << payloadDecoder)


payloadDecoder : String -> Decoder Msg
payloadDecoder type_ =
    case type_ of
        _ ->
            D.fail ("Unrecognized Msg type -> " ++ type_)
