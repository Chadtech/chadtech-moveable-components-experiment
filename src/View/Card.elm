module View.Card exposing
    ( body
    , header
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Animations as Animations
import Css.Global as Global
import Html.Grid as Grid
import Html.Styled as Html exposing (Html, node)
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onClick)
import Style as Style
import Style.Units as Units
import View.Button as Button


view : List Style -> List (Html msg) -> Html msg
view styles =
    Html.node "card"
        [ css [ Css.batch styles, containerStyle ] ]


containerStyle : Style
containerStyle =
    [ Style.outdent
    , backgroundColor Ct.content1
    , boxSizing borderBox
    , displayFlex
    , flexDirection column
    , property "animation-duration" "150ms"
    , [ ( 0, [ Animations.transform [ scale 0 ] ] )
      , ( 100, [ Animations.transform [ scale 1 ] ] )
      ]
        |> Animations.keyframes
        |> animationName
    ]
        |> Css.batch


type alias HeaderPayload msg =
    { title : String
    , closeClickHandler : Maybe msg
    }


header : HeaderPayload msg -> Html msg
header model =
    Grid.row
        []
        [ Grid.column
            [ padding (px Units.size1)
            , displayFlex
            , backgroundColor Ct.content3
            , margin (px Units.size0)
            ]
            [ closeButton model.closeClickHandler
            , Html.node "card-header"
                [ css [ headerStyle ] ]
                [ Html.p
                    [ css [ headerTextStyle ] ]
                    [ Html.text model.title ]
                ]
            ]
        ]


closeButton : Maybe msg -> Html msg
closeButton closeClickHandler =
    case closeClickHandler of
        Just msg ->
            Button.view
                [ css
                    [ Button.styles
                    , width (px Units.size4)
                    , minWidth (px Units.size4)
                    , padding zero
                    , paddingBottom (px 2)
                    ]
                , onClick msg
                ]
                "x"

        Nothing ->
            Html.text ""


headerCloseButton : Html msg
headerCloseButton =
    Html.button
        [ css [ headerCloseButtonStyle ] ]
        [ Html.text "x" ]


headerCloseButtonStyle : Style
headerCloseButtonStyle =
    [ position absolute
    , width (px Units.size4)
    , height (px Units.size4)
    , padding zero
    , paddingBottom (px 2)
    , Style.indent
    , backgroundColor Ct.content2
    , active [ backgroundColor Ct.content0 ]
    , boxSizing borderBox
    , lineHeight (px 14)
    ]
        |> Css.batch


headerTextStyle : Style
headerTextStyle =
    [ color Ct.content0
    , lineHeight (px Units.size4)
    , textAlign center
    ]
        |> Css.batch


headerStyle : Style
headerStyle =
    [ height (px Units.size4)
    , flex (int 1)
    , position relative
    ]
        |> Css.batch


body : List (Html msg) -> Html msg
body children =
    Grid.row
        []
        [ Grid.column
            [ padding (px Units.size1)
            , flexDirection column
            ]
            [ Html.node "card-body"
                [ css [ bodyStyle ] ]
                children
            ]
        ]


bodyStyle : Style
bodyStyle =
    [ boxSizing borderBox
    , backgroundColor Ct.content1
    , flex2 (int 0) (int 1)
    , flexBasis auto
    , displayFlex
    , flexDirection column
    ]
        |> Css.batch
