module Flags exposing (Flags, decoder)

import Data.Size as Size exposing (Size)
import Data.Window as Window exposing (Window)
import Db exposing (Db)
import Dict exposing (Dict)
import Id exposing (Id)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Random exposing (Seed)


type alias Flags =
    { seed : Seed
    , windowSize : Size
    , windows : Db Window
    , savedWindows : Dict String ( Id, Window )
    }


decoder : Decoder Flags
decoder =
    D.succeed Flags
        |> JDP.required "seed" (D.map Random.initialSeed D.int)
        |> JDP.required "windowSize" Size.decoder
        |> JDP.required "model" windowsDecoder
        |> JDP.required "model" savedWindowsDecoder


windowsDecoder : Decoder (Db Window)
windowsDecoder =
    [ D.null Db.empty
    , idWindowPairDecoder
        |> D.list
        |> D.map Db.fromList
        |> D.field "windows"
    ]
        |> D.oneOf


savedWindowsDecoder : Decoder (Dict String ( Id, Window ))
savedWindowsDecoder =
    [ D.null Dict.empty
    , D.map2 Tuple.pair
        (D.field "file-name" D.string)
        (D.field "data" idWindowPairDecoder)
        |> D.list
        |> D.map Dict.fromList
        |> D.field "saved-windows"
    ]
        |> D.oneOf


idWindowPairDecoder : Decoder ( Id, Window )
idWindowPairDecoder =
    D.map2 Tuple.pair
        (D.field "id" Id.decoder)
        (D.field "data" Window.decoder)
