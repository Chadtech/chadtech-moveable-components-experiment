module Style exposing
    ( borderNone
    , center
    , fontSmoothingNone
    , globalStyles
    , hfnss
    , indent
    , outdent
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Global exposing (global)
import Html.Styled as Html exposing (Html)
import Style.Units as Units


globalStyles : Html msg
globalStyles =
    [ Css.Global.p
        [ color Ct.content4
        , margin (px 0)
        , fontSmoothingNone
        , hfnss
        ]
    ]
        |> global


borderNone : Style
borderNone =
    property "border" "none"


indent : Style
indent =
    [ borderLeft3 Units.size0 solid Ct.content0
    , borderTop3 Units.size0 solid Ct.content0
    , borderRight3 Units.size0 solid Ct.content2
    , borderBottom3 Units.size0 solid Ct.content2
    ]
        |> Css.batch


outdent : Style
outdent =
    [ borderLeft3 Units.size0 solid Ct.content2
    , borderTop3 Units.size0 solid Ct.content2
    , borderRight3 Units.size0 solid Ct.content0
    , borderBottom3 Units.size0 solid Ct.content0
    ]
        |> Css.batch


hfnss : Style
hfnss =
    [ fontFamilies [ "HFNSS" ]
    , fontSize (px 32)
    ]
        |> Css.batch


fontSmoothingNone : Style
fontSmoothingNone =
    property "-webkit-font-smoothing" "none"


center : Style
center =
    margin2 zero auto
