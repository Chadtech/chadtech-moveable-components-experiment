module Session exposing
    ( Session
    , setSeed
    , setWindowSize
    )

import Data.Size as Size exposing (Size)
import Random exposing (Seed)



-- TYPES --


type alias Session =
    { seed : Seed
    , windowSize : Size
    }



-- HELPERS --


setWindowSize : Int -> Int -> Session -> Session
setWindowSize width height session =
    { session
        | windowSize =
            { width = width
            , height = height
            }
    }


setSeed : Seed -> Session -> Session
setSeed seed session =
    { session | seed = seed }
