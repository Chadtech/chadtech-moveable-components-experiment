module View.Spinner exposing (view)

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Animations as Animations
import Html.Styled as Html exposing (Html, node)
import Html.Styled.Attributes as Attrs exposing (css)
import Style as Style
import Style.Units as Units


view : List Style -> Html msg
view style =
    Html.div
        [ css [ containerStyle, Css.batch style ] ]
        [ Html.node "spinner"
            [ css [ spinnerStyle ] ]
            []
        ]


spinnerStyle : Style
spinnerStyle =
    [ property "animation-duration" "1000ms"
    , property "animation-iteration-count" "infinite"
    , property "animation-timing-function" "linear"
    , [ ( 0, [ Animations.property "left" "-128px" ] )
      , ( 100, [ Animations.property "left" "384px" ] )
      ]
        |> Animations.keyframes
        |> animationName
    , width Units.size6
    , height Units.size4
    , top (px 0)
    , position absolute
    , backgroundColor Ct.content4
    ]
        |> Css.batch


containerStyle : Style
containerStyle =
    [ position relative
    , backgroundColor Ct.background1
    , height Units.size4
    , overflow hidden
    , width Units.size7
    , Style.indent
    , boxSizing borderBox
    ]
        |> Css.batch
