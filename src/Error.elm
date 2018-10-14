module Error exposing
    ( Error(..)
    , fromFlagsDecode
    , toString
    , view
    )

import Browser
import Html.Styled as Html exposing (Html)
import Json.Decode as D
import Style


type Error
    = FlagsError D.Error


toString : Error -> String
toString error =
    case error of
        FlagsError decodeError ->
            D.errorToString decodeError


fromFlagsDecode : D.Error -> Error
fromFlagsDecode =
    FlagsError


view : Error -> Browser.Document msg
view error =
    { title = "Error"
    , body =
        [ Style.globals
        , Html.p
            []
            [ Html.text (toString error) ]
        ]
            |> List.map Html.toUnstyled
    }
