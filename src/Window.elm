module Window exposing
    ( Model
    , Msg
    , Window(..)
    , initWelcome
    , update
    , view
    )

import Css exposing (..)
import Data.Position exposing (Position)
import Data.Size as Size
import Db exposing (Db)
import Html.Styled as Html exposing (Html)
import Session exposing (Session)
import View.Card as Card
import Window.Welcome as Welcome



-- TYPES --


type alias Model =
    { position : Position
    , window : Window
    }


type Window
    = Welcome Welcome.Model


type Msg
    = WelcomeMsg Welcome.Msg


setWindow : Window -> Model -> Model
setWindow window model =
    { model | window = window }


initWelcome : Session -> Db Model -> Db Model
initWelcome session =
    Db.insert
        Welcome.id
        { position = Size.center session.windowSize
        , window = Welcome Welcome.init
        }



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case ( msg, model.window ) of
        ( WelcomeMsg subMsg, Welcome welcomeModel ) ->
            { model
                | window =
                    welcomeModel
                        |> Welcome.update subMsg
                        |> Welcome
            }



-- VIEW --


view : Model -> Html Msg
view model =
    case model.window of
        Welcome subModel ->
            let
                windowWidth : Float
                windowWidth =
                    Welcome.width subModel
            in
            Card.view
                [ Welcome.cardStyle subModel
                , width (px windowWidth)
                , position absolute
                , top (px model.position.y)
                , (model.position.x - (windowWidth / 2))
                    |> px
                    |> left
                ]
                [ Card.header
                    { title = Welcome.title subModel
                    , closeClickHandler = Nothing
                    }
                , Welcome.view subModel
                ]
                |> Html.map WelcomeMsg
