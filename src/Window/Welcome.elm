module Window.Welcome exposing
    ( Model
    , Msg
    , cardStyle
    , id
    , init
    , title
    , update
    , view
    )

import Css exposing (..)
import Data.Position as Position
import Data.Size as Size exposing (Size)
import Html.Styled as Html exposing (Html)
import Id exposing (Id)
import Session exposing (Session)
import Style.Units as Units
import View.Card as Card



-- TYPES --


type alias Model =
    { card : Card.Model }


type Msg
    = Noop


init : Session -> Model
init session =
    { card =
        session.windowSize
            |> Size.center
            |> Position.subtractFromX (width / 2)
            |> Card.initFromPosition
    }


id : Id
id =
    Id.fromString "welcome"



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        Noop ->
            model



-- VIEW --


title : Model -> String
title _ =
    "welcome"


view : Model -> List (Html Msg)
view model =
    [ Card.body
        [ Html.p
            []
            [ Html.text
                """
            What would you like to open?          
            """
            ]
        ]
    ]



-- STYLE --


cardStyle : Model -> Style
cardStyle _ =
    [ Css.width (px width) ]
        |> Css.batch


width : Float
width =
    Units.size9
