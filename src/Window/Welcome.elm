module Window.Welcome exposing
    ( Model
    , Msg
    , cardStyle
    , id
    , init
    , title
    , update
    , view
    , width
    )

import Css exposing (..)
import Data.Size exposing (Size)
import Html.Styled as Html exposing (Html)
import Id exposing (Id)
import Style.Units as Units
import View.Card as Card



-- TYPES --


type alias Model =
    {}


type Msg
    = Noop


init : Model
init =
    {}


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
    "Welcome to CtOS"


view : Model -> Html Msg
view model =
    Html.p [] [ Html.text "WELCOME!!" ]



-- STYLE --


width : Model -> Float
width _ =
    Units.size8


cardStyle : Model -> Style
cardStyle _ =
    Css.batch []
