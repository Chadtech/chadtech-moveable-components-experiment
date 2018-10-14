module View.Card exposing
    ( body
    , extraLargeHeight
    , extraLargeWidth
    , extraSmallHeight
    , extraSmallWidth
    , header
    , largeHeight
    , largeWidth
    , mediumHeight
    , mediumWidth
    , smallHeight
    , smallWidth
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Animations as Animations
import Css.Global as Global
import Html.Grid as Grid
import Html.Styled as Html exposing (Html, node)
import Html.Styled.Attributes as Attrs exposing (css)
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


type alias HeaderModel =
    { title : String
    , shouldShowCloseButton : Bool
    }


header : HeaderModel -> Html msg
header model =
    Grid.row
        []
        [ Grid.column
            [ padding Units.size1
            , displayFlex
            , backgroundColor Ct.content4
            , margin Units.size0
            ]
            [ closeButton model.shouldShowCloseButton
            , Html.node "card-header"
                [ css [ headerStyle ] ]
                [ Html.p
                    [ css [ headerTextStyle ] ]
                    [ Html.text model.title ]
                ]
            ]
        ]


closeButton : Bool -> Html msg
closeButton shouldShowCloseButton =
    if shouldShowCloseButton then
        Button.view
            [ css
                [ Button.secondary
                , width Units.size4
                , minWidth Units.size4
                , padding zero
                , paddingBottom (px 2)
                ]
            ]
            "x"

    else
        Html.text ""


headerCloseButton : Html msg
headerCloseButton =
    Html.button
        [ css [ headerCloseButtonStyle ] ]
        [ Html.text "x" ]


headerCloseButtonStyle : Style
headerCloseButtonStyle =
    [ position absolute
    , width Units.size4
    , height Units.size4
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
    , lineHeight Units.size4
    , textAlign center
    ]
        |> Css.batch


headerStyle : Style
headerStyle =
    [ height Units.size4
    , flex (int 1)
    , position relative
    ]
        |> Css.batch


body : List (Html msg) -> Html msg
body children =
    Grid.row
        []
        [ Grid.column
            [ padding Units.size1
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


extraSmallWidth : Style
extraSmallWidth =
    width Units.size8


extraSmallHeight : Style
extraSmallHeight =
    height Units.size7


smallWidth : Style
smallWidth =
    width Units.size8


smallHeight : Style
smallHeight =
    height Units.size8


mediumWidth : Style
mediumWidth =
    width Units.size8


mediumHeight : Style
mediumHeight =
    height Units.size9


largeWidth : Style
largeWidth =
    width Units.size10


largeHeight : Style
largeHeight =
    height Units.size9


extraLargeWidth : Style
extraLargeWidth =
    width Units.size9


extraLargeHeight : Style
extraLargeHeight =
    height Units.size10
