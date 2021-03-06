module Data.Window.TextWriter exposing
    ( Model
    , bye
    , cardStyle
    , decoder
    , encode
    , init
    , mapCard
    , readme
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


readme : Model
readme =
    { card =
        Card.initFromPosition { x = 50, y = 50 }
    , text = """This is www.ct-os.us . Its like a little operating system in your web browser. Its just something I made for fun, and to act as a test-bed for different programming techniques I want to practice."""
    , fileName = "readme"
    }


bye : Model
bye =
    { card =
        Card.initFromPosition
            { x = 100, y = 100 }
    , text = """"""
    , fileName = "bye"
    }


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
