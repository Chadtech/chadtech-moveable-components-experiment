module Body exposing
    ( Msg
    , update
    , view
    )

import Css exposing (..)
import Db
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Id exposing (Id)
import Model exposing (Model)
import Window exposing (Window)



-- TYPES --


type Msg
    = WindowMsg Id Window.Msg



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        WindowMsg id subMsg ->
            Model.mapWindow
                id
                (Window.update subMsg)
                model



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


viewWindow : ( Id, Window.Model ) -> Html Msg
viewWindow ( id, model ) =
    model
        |> Window.view
        |> Html.map (WindowMsg id)
