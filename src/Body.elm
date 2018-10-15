module Body exposing
    ( Msg
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



-- UPDATE --


update : Msg -> Model -> Model
update msg =
    case msg of
        WindowMsg id subMsg ->
            Window.update id subMsg



-- VIEW --


view : Model -> Html Msg
view model =
    model.windows
        |> Db.toList
        |> List.map viewWindow
        |> Html.section
            [ Attrs.css [ containerStyle ] ]


containerStyle : Style
containerStyle =
    [ width (pct 100)
    , position relative
    ]
        |> Css.batch


viewWindow : ( Id, Window ) -> Html Msg
viewWindow ( id, window ) =
    Html.map
        (WindowMsg id)
        (Window.view window)
