module Data.Window exposing
    ( Window(..)
    , bye
    , cardModel
    , cardStyle
    , decoder
    , encode
    , mapCalculator
    , mapCard
    , mapTextWriter
    , mapTungsten
    , mapWelcome
    , readme
    , title
    )

import Css exposing (Style)
import Data.Window.TextWriter as TextWriter
import Data.Window.Welcome as Welcome
import Id exposing (Id)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import View.Card as Card
import Window.Calculator as Calculator
import Window.Tungsten as Tungsten


type Window
    = Welcome Welcome.Model
    | TextWriter TextWriter.Model
    | Tungsten Tungsten.Model
    | Calculator Calculator.Model


mapWelcome : (Welcome.Model -> Welcome.Model) -> Window -> Window
mapWelcome f window =
    case window of
        Welcome model ->
            Welcome (f model)

        _ ->
            window


mapTextWriter : (TextWriter.Model -> TextWriter.Model) -> Window -> Window
mapTextWriter f window =
    case window of
        TextWriter model ->
            TextWriter (f model)

        _ ->
            window


mapTungsten : (Tungsten.Model -> Tungsten.Model) -> Window -> Window
mapTungsten f window =
    case window of
        Tungsten model ->
            Tungsten (f model)

        _ ->
            window


mapCalculator : (Calculator.Model -> Calculator.Model) -> Window -> Window
mapCalculator f window =
    case window of
        Calculator model ->
            Calculator (f model)

        _ ->
            window


cardStyle : Window -> Style
cardStyle window =
    [ Card.positioningStyle (cardModel window)
    , cardStyleFromWindowModel window
    ]
        |> Css.batch


cardStyleFromWindowModel : Window -> Style
cardStyleFromWindowModel window =
    case window of
        Welcome model ->
            Welcome.cardStyle model

        TextWriter model ->
            TextWriter.cardStyle model

        Tungsten model ->
            Tungsten.cardStyle model

        Calculator model ->
            Calculator.cardStyle model


title : Window -> String
title window =
    case window of
        Welcome model ->
            Welcome.title model

        TextWriter model ->
            TextWriter.title model

        Tungsten model ->
            Tungsten.title model

        Calculator model ->
            Calculator.title model


cardModel : Window -> Card.Model
cardModel window =
    case window of
        Welcome model ->
            model.card

        TextWriter model ->
            model.card

        Tungsten model ->
            model.card

        Calculator model ->
            model.card


mapCard : (Card.Model -> Card.Model) -> Window -> Window
mapCard f window =
    case window of
        Welcome model ->
            Welcome (Welcome.mapCard f model)

        TextWriter model ->
            TextWriter (TextWriter.mapCard f model)

        Tungsten model ->
            Tungsten (Tungsten.mapCard f model)

        Calculator model ->
            Calculator (Calculator.mapCard f model)


readme : ( Id, Window )
readme =
    ( Id.fromString "readme", TextWriter TextWriter.readme )


bye : Window
bye =
    TextWriter TextWriter.bye


encode : Window -> E.Value
encode window =
    case window of
        Welcome model ->
            [ ( "type", E.string "welcome" )
            , ( "data", Welcome.encode model )
            ]
                |> E.object

        TextWriter model ->
            [ ( "type", E.string "text-writer" )
            , ( "data", TextWriter.encode model )
            ]
                |> E.object

        Tungsten model ->
            [ ( "type", E.string "tungsten" )
            , ( "data", Tungsten.encode model )
            ]
                |> E.object

        Calculator model ->
            [ ( "type", E.string "calculator" )
            , ( "data", Calculator.encode model )
            ]
                |> E.object


decoder : Decoder Window
decoder =
    D.string
        |> D.field "type"
        |> D.andThen decoderFromType


dataDecoder : (a -> Window) -> Decoder a -> Decoder Window
dataDecoder windowCtor windowModelDecoder =
    windowModelDecoder
        |> D.field "data"
        |> D.map windowCtor


decoderFromType : String -> Decoder Window
decoderFromType type_ =
    case type_ of
        "welcome" ->
            dataDecoder Welcome Welcome.decoder

        "text-writer" ->
            dataDecoder TextWriter TextWriter.decoder

        "tungsten" ->
            dataDecoder Tungsten Tungsten.decoder

        "calculator" ->
            dataDecoder Calculator Calculator.decoder

        _ ->
            D.fail "unrecognized window type"
