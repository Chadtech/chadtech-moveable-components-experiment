module Header exposing
    ( Msg
    , update
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Db
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Model exposing (Model)
import Style.Units as Units
import View.Button as Button
import Window
import Window.Welcome as Welcome



-- TYPES --


type Msg
    = CtClicked



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        CtClicked ->
            if Db.member Welcome.id model.windows then
                Model.setTopWindow Welcome.id model

            else
                Model.initWelcomeWindow model



-- VIEW --


view : Html Msg
view =
    Html.nav
        [ Attrs.css
            [ width (pct 100)
            , height (px Units.size5)
            , backgroundColor Ct.content1
            , borderBottom3 (px Units.size0) solid Ct.content0
            , displayFlex
            ]
        ]
        [ Button.view
            [ Attrs.css
                [ Button.styles
                , margin (px Units.size0)
                , height initial
                , minWidth (px Units.size5)
                ]
            , Events.onClick CtClicked
            ]
            "Ct"
        ]
