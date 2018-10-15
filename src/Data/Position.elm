module Data.Position exposing
    ( Position
    , subtractFromX
    )


type alias Position =
    { x : Float
    , y : Float
    }


subtractFromX : Float -> Position -> Position
subtractFromX f position =
    { position | x = position.x - f }
