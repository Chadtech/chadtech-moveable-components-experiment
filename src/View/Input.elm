module View.Input exposing
    ( textareaAttrs
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Style
import Style.Units as Units


view : List Style -> List (Attribute msg) -> Html msg
view styles attrs =
    Html.input
        (baseAttrs styles ++ attrs)
        []


inputStyle : Style
inputStyle =
    [ backgroundColor Ct.background1
    , Style.borderNone
    , outline none
    , boxSizing borderBox
    , Style.indent
    , height (px Units.size4)
    , Style.hfnss
    , color Ct.content4
    , Style.fontSmoothingNone
    , width (pct 100)
    , padding2 zero paddingSize
    ]
        |> Css.batch


paddingSize : Px
paddingSize =
    px Units.size2


textareaAttrs : List Style -> List (Attribute msg)
textareaAttrs styles =
    [ Attrs.css
        [ inputStyle
        , padding paddingSize
        , Css.batch styles
        ]
    , Attrs.spellcheck False
    ]


textareaStyle : Style
textareaStyle =
    [ backgroundColor Ct.background1
    , Style.borderNone
    , outline none
    , boxSizing borderBox
    , Style.indent
    , Style.hfnss
    , color Ct.content4
    , Style.fontSmoothingNone
    , width (pct 100)
    , padding2 zero (px Units.size2)
    ]
        |> Css.batch


baseAttrs : List Style -> List (Attribute msg)
baseAttrs styles =
    [ Attrs.css [ inputStyle, Css.batch styles ]
    , Attrs.spellcheck False
    ]
