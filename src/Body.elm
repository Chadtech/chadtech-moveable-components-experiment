module Body exposing
    ( Msg
    , subscriptions
    , update
    , view
    )

import Css exposing (..)
import Data.Window exposing (Window)
import Db
import Dict
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Id exposing (Id)
import Model exposing (Model)
import Style
import Style.Units as Units
import View.Button as Button
import View.Card as Card
import Window



-- TYPES --


type Msg
    = WindowMsg Id Window.Msg
    | SavedWindowClicked String



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.topWindow of
        Just topWindowsId ->
            Sub.map
                (WindowMsg topWindowsId)
                (Window.subscriptions topWindowsId model)

        Nothing ->
            Sub.none



-- UPDATE --


update : Msg -> Model -> Model
update msg =
    case msg of
        WindowMsg id subMsg ->
            Window.update id subMsg

        SavedWindowClicked fileName ->
            Model.openSavedWindow fileName



-- VIEW --


view : Model -> Html Msg
view model =
    [ model
        |> Model.windows
        |> List.reverse
        |> List.map (viewWindow model.topWindow)
    , model.savedWindows
        |> Dict.toList
        |> List.map savedWindowView
    ]
        |> List.concat
        |> Html.section
            [ Attrs.css
                [ containerStyle
                , backgroundImage (url "https://upload.wikimedia.org/wikipedia/commons/1/17/FLW_Gammage_Auditorium_ASU_PHX_AZ_20186.JPG")
                ]
            ]


containerStyle : Style
containerStyle =
    [ width (pct 100)
    , position relative
    ]
        |> Css.batch


viewWindow : Maybe Id -> ( Id, Window ) -> Html Msg
viewWindow topWindow ( id, window ) =
    Html.map
        (WindowMsg id)
        (Window.view (topWindow == Just id) window)


savedWindowView : ( String, ( Id, Window ) ) -> Html Msg
savedWindowView ( fileName, ( id, window ) ) =
    Button.view
        [ Attrs.css
            [ Button.styles
            , Style.borderNone
            , margin (px Units.size4)
            , minWidth (px Units.size4)
            , height (px Units.size5)
            ]
        , Events.onClick (SavedWindowClicked fileName)
        ]
        fileName
