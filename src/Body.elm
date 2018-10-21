module Body exposing
    ( Msg
    , subscriptions
    , update
    , view
    )

import Css exposing (..)
import Data.Window exposing (Window)
import Db
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Id exposing (Id)
import Model exposing (Model)
import View.Card as Card
import Window



-- TYPES --


type Msg
    = WindowMsg Id Window.Msg



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



-- VIEW --


view : Model -> Html Msg
view model =
    model
        |> Model.windows
        |> List.reverse
        |> List.map (viewWindow model.topWindow)
        |> Html.section
            [ Attrs.css [ containerStyle ] ]


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
