module Data.Window exposing
    ( Window(..)
    , card
    , mapCard
    , mapWelcome
    )

import View.Card as Card
import Window.Welcome as Welcome


type Window
    = Welcome Welcome.Model


mapWelcome : (Welcome.Model -> Welcome.Model) -> Window -> Window
mapWelcome f window =
    case window of
        Welcome model ->
            Welcome (f model)


mapCard : (Card.Model -> Card.Model) -> Window -> Window
mapCard f window =
    case window of
        Welcome welcomeModel ->
            Welcome (Card.mapIn f welcomeModel)


card : Window -> Card.Model
card window =
    case window of
        Welcome model ->
            model.card
