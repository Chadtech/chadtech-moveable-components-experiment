module Data.Size exposing
    ( Size
    , center
    , decoder
    )

import Data.Position exposing (Position)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as JDP


type alias Size =
    { width : Int
    , height : Int
    }


center : Size -> Position
center { width, height } =
    { x = toFloat (width // 2)
    , y = toFloat (height // 2)
    }


decoder : Decoder Size
decoder =
    D.succeed Size
        |> JDP.required "width" D.int
        |> JDP.required "height" D.int
