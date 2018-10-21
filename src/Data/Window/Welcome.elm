module Data.Window.Welcome exposing
    ( Model
    , cardStyle
    , id
    , init
    , mapCard
    , title
    )

import Css exposing (..)
import Data.Position as Position
import Data.Size as Size exposing (Size)
import Id exposing (Id)
import Session exposing (Session)
import Style.Units as Units
import View.Card as Card



-- TYPES --


type alias Model =
    { card : Card.Model }


id : Id
id =
    Id.fromString "welcome"


init : Session -> Model
init session =
    { card =
        session.windowSize
            |> Size.center
            |> Position.subtractFromX (width / 2)
            |> Card.initFromPosition
    }


mapCard : (Card.Model -> Card.Model) -> Model -> Model
mapCard f model =
    { model | card = f model.card }


title : Model -> String
title _ =
    "welcome"



-- STYLE --


cardStyle : Model -> Style
cardStyle _ =
    [ Css.width (px width) ]
        |> Css.batch


width : Float
width =
    Units.size10
