module Flags exposing (Flags, decoder)

import Data.Size as Size exposing (Size)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Random exposing (Seed)


type alias Flags =
    { seed : Seed
    , windowSize : Size
    }


decoder : Decoder Flags
decoder =
    D.succeed Flags
        |> JDP.required "seed" (D.map Random.initialSeed D.int)
        |> JDP.required "windowSize" Size.decoder
