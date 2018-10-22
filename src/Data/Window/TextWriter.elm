module Data.Window.TextWriter exposing
    ( Model
    , cardStyle
    , decoder
    , encode
    , init
    , mapCard
    , title
    )

import Css exposing (..)
import Data.Position as Position
import Data.Size as Size exposing (Size)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Json.Encode as E
import Session exposing (Session)
import Style.Units as Units
import View.Card as Card


type alias Model =
    { card : Card.Model
    , text : String
    , fileName : String
    }


init : Session -> Model
init session =
    { card =
        session.windowSize
            |> Size.center
            |> Position.subtractFromX (width / 2)
            |> Position.subtractFromY (height / 2)
            |> Card.initFromPosition
    , text = ""
    , fileName = "untitled"
    }


mapCard : (Card.Model -> Card.Model) -> Model -> Model
mapCard f model =
    { model | card = f model.card }


title : Model -> String
title model =
    "text writer : " ++ model.fileName


cardStyle : Model -> Style
cardStyle _ =
    [ Css.width (px width) ]
        |> Css.batch


width : Float
width =
    Units.size10


height : Float
height =
    568


encode : Model -> E.Value
encode model =
    [ ( "card", Card.encode model.card )
    , ( "text", E.string model.text )
    , ( "file-name", E.string model.fileName )
    ]
        |> E.object


decoder : Decoder Model
decoder =
    D.succeed Model
        |> JDP.required "card" Card.decoder
        |> JDP.required "text" D.string
        |> JDP.required "file-name" D.string
