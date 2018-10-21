module Window.TextWriter exposing
    ( Model
    , Msg
    , cardStyle
    , init
    , mapCard
    , title
    , update
    , view
    )

import Css exposing (..)
import Data.Position as Position
import Data.Size as Size exposing (Size)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Events as Events
import Session exposing (Session)
import Style.Units as Units
import View.Card as Card
import View.Input as Input


type alias Model =
    { card : Card.Model
    , text : String
    }


type Msg
    = TextareaUpdated String


init : Session -> Model
init session =
    { card =
        session.windowSize
            |> Size.center
            |> Position.subtractFromX (width / 2)
            |> Position.subtractFromY (height / 2)
            |> Card.initFromPosition
    , text = ""
    }


mapCard : (Card.Model -> Card.Model) -> Model -> Model
mapCard f model =
    { model | card = f model.card }



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextareaUpdated str ->
            { model | text = str }



-- STYLE --


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



-- VIEW --


title : Model -> String
title _ =
    "text writer"


view : Model -> List (Html Msg)
view model =
    [ Card.body
        [ Grid.row
            []
            [ Grid.column
                []
                [ textView model ]
            ]
        ]
    ]


textView : Model -> Html Msg
textView model =
    Html.textarea
        textareaAttrs
        [ Html.text model.text ]


textareaAttrs : List (Attribute Msg)
textareaAttrs =
    [ Events.onInput TextareaUpdated ]
        ++ Input.textareaAttrs
            [ minHeight (px Units.size9) ]
