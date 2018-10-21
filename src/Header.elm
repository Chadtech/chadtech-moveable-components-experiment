module Header exposing
    ( Msg
    , update
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Data.Window as Window exposing (Window)
import Data.Window.Welcome as Welcome
import Db
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Id exposing (Id)
import Model exposing (Model)
import Style.Units as Units
import View.Button as Button
import Window



-- TYPES --


type Msg
    = CtClicked
    | ProgramButtonClicked Id



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        CtClicked ->
            if Db.member Welcome.id model.windows then
                Model.setTopWindow Welcome.id model

            else
                Model.initWelcomeWindow model

        ProgramButtonClicked id ->
            Model.setTopWindow id model



-- VIEW --


view : Model -> Html Msg
view model =
    Html.nav
        [ Attrs.css
            [ width (pct 100)
            , height (px Units.size5)
            , backgroundColor Ct.content1
            , borderBottom3 (px Units.size0) solid Ct.content0
            , displayFlex
            ]
        ]
        (viewContent model)


viewContent : Model -> List (Html Msg)
viewContent model =
    Button.view
        [ Attrs.css
            [ Button.styles
            , margin (px Units.size0)
            , marginRight (px Units.size1)
            , height initial
            , minWidth (px Units.size5)
            ]
        , Events.onClick CtClicked
        ]
        "Ct"
        :: viewPrograms model


viewPrograms : Model -> List (Html Msg)
viewPrograms model =
    model.windows
        |> Db.toList
        |> List.map (programButton model)


programButton : Model -> ( Id, Window ) -> Html Msg
programButton model ( id, window ) =
    Button.view
        [ Attrs.css
            [ programButtonBaseAttrs model id
            , margin (px Units.size0)
            , height initial
            , minWidth (px Units.size6)
            ]
        , Events.onClick (ProgramButtonClicked id)
        ]
        (Window.title window)


programButtonBaseAttrs : Model -> Id -> Style
programButtonBaseAttrs model id =
    case model.topWindow of
        Just topWindow ->
            if topWindow == id then
                Button.selected

            else
                Button.styles

        Nothing ->
            Button.styles
