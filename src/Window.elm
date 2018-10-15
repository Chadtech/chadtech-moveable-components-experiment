module Window exposing
    ( Msg
    , cardStyle
    , title
    , update
    , view
    )

import Css exposing (..)
import Data.Position exposing (Position)
import Data.Size as Size
import Data.Window as Window exposing (Window(..))
import Db exposing (Db)
import Html.Styled as Html exposing (Html)
import Id exposing (Id)
import Model exposing (Model)
import Session exposing (Session)
import View.Card as Card
import Window.Welcome as Welcome



-- TYPES --


type Msg
    = CloseClicked
    | CardMsg Card.Msg
    | WelcomeMsg Welcome.Msg



-- UPDATE --


update : Id -> Msg -> Model -> Model
update id msg =
    case msg of
        CloseClicked ->
            Model.removeWindow id

        CardMsg subMsg ->
            updateCard id subMsg

        WelcomeMsg subMsg ->
            updateWelcome id subMsg


updateCard : Id -> Card.Msg -> Model -> Model
updateCard id msg =
    Card.update msg
        |> Window.mapCard
        |> Model.mapWindow id


updateWelcome : Id -> Welcome.Msg -> Model -> Model
updateWelcome id msg =
    Welcome.update msg
        |> Window.mapWelcome
        |> Model.mapWindow id



-- VIEW --


view : Window -> Html Msg
view window =
    Card.view
        { title = title window
        , closeClickHandler = Just CloseClicked
        , positioning =
            ( CardMsg
            , Window.card window
            )
                |> Just
        }
        [ cardStyle window ]
        (viewContent window)


viewContent : Window -> List (Html Msg)
viewContent window =
    case window of
        Welcome subModel ->
            subModel
                |> Welcome.view
                |> mapManyHtml WelcomeMsg


mapManyHtml : (a -> b) -> List (Html a) -> List (Html b)
mapManyHtml f =
    List.map (Html.map f)


cardStyle : Window -> Style
cardStyle window =
    case window of
        Welcome subModel ->
            Welcome.cardStyle subModel


title : Window -> String
title window =
    case window of
        Welcome subModel ->
            Welcome.title subModel
