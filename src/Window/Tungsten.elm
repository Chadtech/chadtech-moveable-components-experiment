module Window.Tungsten exposing
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
import Data.Size as Size
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Json.Decode as D
import Session exposing (Session)
import Style
import Style.Units as Units
import View.Button as Button
import View.Card as Card
import View.Input as Input



-- TYPES --


type alias Model =
    { card : Card.Model
    , urlField : String
    , url : String
    }


type Msg
    = UrlFieldUpdated String
    | GoClicked


init : Session -> Model
init session =
    let
        url =
            "http://www.4chan.org/g"
    in
    { card =
        session.windowSize
            |> Size.center
            |> Position.subtractFromX (width / 2)
            |> Position.subtractFromY (height / 2)
            |> Card.initFromPosition
    , url = url
    , urlField = url
    }


mapCard : (Card.Model -> Card.Model) -> Model -> Model
mapCard f model =
    { model | card = f model.card }



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        UrlFieldUpdated str ->
            { model | urlField = str }

        GoClicked ->
            { model | url = model.urlField }



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
title model =
    if String.length model.url > 16 then
        "Tungsten .." ++ String.right 14 model.url

    else
        "Tungsten " ++ model.url


view : Model -> List (Html Msg)
view model =
    [ Card.body
        [ Grid.row
            [ marginBottom (px Units.size1) ]
            [ Grid.column
                [ marginRight (px Units.size0) ]
                [ urlView model ]
            , Grid.column
                [ flex none ]
                [ Button.view
                    [ Attrs.css [ Button.styles ]
                    , Events.onClick GoClicked
                    ]
                    "go"
                ]
            ]
        , Grid.row
            []
            [ Grid.column
                []
                [ Html.iframe
                    [ Attrs.src model.url
                    , Attrs.css
                        [ minWidth (pct 100)
                        , minHeight (px Units.size9)
                        , Style.indent
                        ]
                    ]
                    []
                ]
            ]
        ]
    ]


urlView : Model -> Html Msg
urlView model =
    Input.view
        []
        [ Attrs.value model.urlField
        , Events.onInput UrlFieldUpdated
        ]
