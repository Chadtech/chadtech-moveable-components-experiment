module Window exposing
    ( Msg
    , subscriptions
    , update
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Data.Position exposing (Position)
import Data.Size as Size
import Data.Window as Window exposing (Window(..))
import Db exposing (Db)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Id exposing (Id)
import Model exposing (Model)
import Session exposing (Session)
import View.Card as Card
import Window.Calculator as Calculator
import Window.TextWriter as TextWriter
import Window.Tungsten as Tungsten
import Window.Welcome as Welcome



-- TYPES --


type Msg
    = CloseClicked
    | HeaderClicked
    | CardMsg Card.Msg
    | WelcomeMsg Welcome.Msg
    | TextWriterMsg TextWriter.Msg
    | TungstenMsg Tungsten.Msg
    | CalculatorMsg Calculator.Msg



-- SUBSCRIPTIONS --


subscriptions : Id -> Model -> Sub Msg
subscriptions id model =
    id
        |> Db.get model.windows
        |> Maybe.map (Card.subscriptions << Window.cardModel)
        |> Maybe.withDefault Sub.none
        |> Sub.map CardMsg



-- UPDATE --


update : Id -> Msg -> Model -> Model
update id msg =
    case msg of
        CloseClicked ->
            Model.removeWindow id

        HeaderClicked ->
            Model.setTopWindow id

        CardMsg subMsg ->
            subMsg
                |> Card.update
                |> Window.mapCard
                |> Model.mapWindow id

        WelcomeMsg subMsg ->
            updateWelcome id subMsg

        TextWriterMsg subMsg ->
            updateTextWriter id subMsg

        TungstenMsg subMsg ->
            updateTungsten id subMsg

        CalculatorMsg subMsg ->
            updateCalculator id subMsg


updateWelcome : Id -> Welcome.Msg -> Model -> Model
updateWelcome id msg model =
    case Db.get model.windows id of
        Just (Welcome welcomeModel) ->
            let
                ( newMainModel, newWelcomeModel ) =
                    Welcome.update msg model welcomeModel
            in
            Model.setWindow id (Welcome newWelcomeModel) newMainModel

        _ ->
            model


updateTextWriter : Id -> TextWriter.Msg -> Model -> Model
updateTextWriter id msg model =
    case Db.get model.windows id of
        Just (TextWriter textWriterModel) ->
            let
                ( newMainModel, newTextWriterModel ) =
                    TextWriter.update msg model id textWriterModel
            in
            Model.setWindow id (TextWriter newTextWriterModel) newMainModel

        _ ->
            model


updateTungsten : Id -> Tungsten.Msg -> Model -> Model
updateTungsten id msg =
    msg
        |> Tungsten.update
        |> Window.mapTungsten
        |> Model.mapWindow id


updateCalculator : Id -> Calculator.Msg -> Model -> Model
updateCalculator id msg =
    msg
        |> Calculator.update
        |> Window.mapCalculator
        |> Model.mapWindow id



-- VIEW --


view : Bool -> Window -> Html Msg
view isTopWindow window =
    Card.view
        [ Window.cardStyle window
        , windowZIndex isTopWindow
        ]
        (viewContent isTopWindow window)


windowZIndex : Bool -> Style
windowZIndex isTopWindow =
    if isTopWindow then
        zIndex (int 50)

    else
        zIndex (int 30)


viewContent : Bool -> Window -> List (Html Msg)
viewContent isTopWindow window =
    Card.header
        (headerStyle isTopWindow)
        [ Card.closeButton CloseClicked
        , Card.headerContent
            headerAttrs
            [ Card.headerTitle (Window.title window) ]
        ]
        :: viewWindow window


headerAttrs : List (Attribute Msg)
headerAttrs =
    [ Events.onMouseUp HeaderClicked ]
        ++ mapAttrs CardMsg Card.headerMouseEvents


headerStyle : Bool -> List Style
headerStyle isTopWindow =
    if isTopWindow then
        []

    else
        [ Card.unfocusedHeader ]


mapAttrs : (a -> b) -> List (Attribute a) -> List (Attribute b)
mapAttrs f =
    List.map (Attrs.map f)


viewWindow : Window -> List (Html Msg)
viewWindow window =
    case window of
        Welcome _ ->
            Welcome.view
                |> mapManyHtml WelcomeMsg

        TextWriter subModel ->
            subModel
                |> TextWriter.view
                |> mapManyHtml TextWriterMsg

        Tungsten subModel ->
            subModel
                |> Tungsten.view
                |> mapManyHtml TungstenMsg

        Calculator subModel ->
            subModel
                |> Calculator.view
                |> mapManyHtml CalculatorMsg


mapManyHtml : (a -> b) -> List (Html a) -> List (Html b)
mapManyHtml f =
    List.map (Html.map f)
