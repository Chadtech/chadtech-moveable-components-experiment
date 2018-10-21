module Data.Position exposing
    ( Position
    , browserDecoder
    , subtractFromX
    , subtractFromY
    )

import Json.Decode as D exposing (Decoder)


type alias Position =
    { x : Float
    , y : Float
    }


subtractFromX : Float -> Position -> Position
subtractFromX f position =
    { position | x = position.x - f }


subtractFromY : Float -> Position -> Position
subtractFromY f position =
    { position | y = position.y - f }


browserDecoder : Decoder Position
browserDecoder =
    D.map2 Position
        (D.field "clientX" D.float)
        (D.field "clientY" D.float)
