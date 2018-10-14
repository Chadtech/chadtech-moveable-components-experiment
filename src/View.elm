module View exposing (view)

import Browser
import Css exposing (..)
import Html.Custom
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , div
        , input
        , p
        )
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onInput)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Style


view : Model -> Browser.Document Msg
view model =
    { title = "Chadtech"
    , body =
        []
            |> List.map Html.toUnstyled
    }
