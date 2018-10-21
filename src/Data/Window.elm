module Data.Window exposing
    ( Window(..)
    , cardModel
    , cardStyle
    , mapCalculator
    , mapCard
    , mapTextWriter
    , mapTungsten
    , mapWelcome
    , title
    )

import Css exposing (Style)
import Data.Window.Welcome as Welcome
import View.Card as Card
import Window.Calculator as Calculator
import Window.TextWriter as TextWriter
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
