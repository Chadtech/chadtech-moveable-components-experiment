module Session exposing
    ( Session
    , setWindowSize
    )

import Data.Size as Size exposing (Size)
import Random exposing (Seed)


type alias Session =
    { seed : Seed
    , windowSize : Size
    }


setWindowSize : Int -> Int -> Session -> Session
setWindowSize width height session =
    { session
        | windowSize =
            { width = width
            , height = height
            }
    }
