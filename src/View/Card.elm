module View.Card exposing
    ( Model
    , Msg
    , Payload
    , body
    , initFromPosition
    , mapIn
    , subscriptions
    , update
    , view
    )

import Browser.Events exposing (onMouseMove)
import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Animations as Animations
import Css.Global as Global
import Data.Position exposing (Position)
import Html.Events.Extra.Mouse as Mouse
import Html.Grid as Grid
import Html.Styled as Html exposing (Html, node)
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onClick)
import Json.Decode as D exposing (Decoder)
import Style as Style
import Style.Units as Units
import View.Button as Button



-- TYPES --


type Msg
    = MouseDown Mouse.Event
    | MouseMove D.Value


type MouseState
    = ReadyForClick
    | ClickAt ( Float, Float )


type alias Model =
    { x : Float
    , y : Float
    , mouseState : MouseState
    }


mapIn : (Model -> Model) -> { a | card : Model } -> { a | card : Model }
mapIn f record =
    { record | card = f record.card }


initFromPosition : Position -> Model
initFromPosition position =
    { x = position.x
    , y = position.y
    , mouseState = ReadyForClick
    }


type alias Payload msg =
    { title : String
    , closeClickHandler : Maybe msg
    , positioning : Maybe ( Msg -> msg, Model )
    }



-- SUBSCRIPTIONS --


subscriptions : Sub Msg
subscriptions =
    [ onMouseMove (D.map MouseMove D.value)
    ]
        |> Sub.batch



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseDown { offsetPos } ->
            let
                ( x, y ) =
                    offsetPos
            in
            { model
                | mouseState =
                    ClickAt ( x - 8, y - 42 )
            }

        MouseMove json ->
            let
                _ =
                    Debug.log "MOVING" json
            in
            model



-- VIEW --


view : Payload msg -> List Style -> List (Html msg) -> Html msg
view payload styles children =
    Html.node "card"
        [ css
            [ Css.batch styles
            , containerStyle
            , Css.batch (positioningStyles payload)
            ]
        ]
        (viewHeader payload :: children)


positioningStyles : Payload msg -> List Style
positioningStyles payload =
    case payload.positioning of
        Just ( _, model ) ->
            [ position absolute
            , left (px model.x)
            , top (px model.y)
            ]

        Nothing ->
            []


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


viewHeader : Payload msg -> Html msg
viewHeader payload =
    Grid.row
        []
        [ Grid.column
            [ padding (px Units.size1)
            , displayFlex
            , backgroundColor Ct.content3
            , margin (px Units.size0)
            ]
            [ closeButton payload.closeClickHandler
            , headerContent payload
            ]
        ]


headerContent : Payload msg -> Html msg
headerContent payload =
    case payload.positioning of
        Just ( toMsg, model ) ->
            Html.node "card-header"
                [ css
                    [ headerStyle ]
                , Mouse.onDown MouseDown
                    |> Attrs.fromUnstyled
                ]
                [ title payload.title ]
                |> Html.map toMsg

        Nothing ->
            Html.node "card-header"
                [ css [ headerStyle ] ]
                [ title payload.title ]


title : String -> Html msg
title str =
    Html.p
        [ css [ headerTextStyle ] ]
        [ Html.text str ]


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
