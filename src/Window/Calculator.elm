module Window.Calculator exposing
    ( Model
    , Msg
    , cardStyle
    , decoder
    , encode
    , init
    , mapCard
    , title
    , update
    , view
    )

import Css exposing (..)
import Data.Position as Position
import Data.Size as Size
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Json.Encode as E
import Session exposing (Session)
import Style.Units as Units
import View.Button as Button
import View.Card as Card
import View.Input as Input



-- TYPES --


type alias Model =
    { card : Card.Model
    , fieldInt : Int
    , fieldDecimal : Int
    , decimalMode : Bool
    , calculation : Calculation
    }


flipSign : Model -> Model
flipSign model =
    { model | fieldInt = -1 * model.fieldInt }


turnOffDecimalMode : Model -> Model
turnOffDecimalMode model =
    { model | decimalMode = False }


fieldToString : Model -> String
fieldToString model =
    [ String.fromInt model.fieldInt
    , String.fromInt model.fieldDecimal
    ]
        |> String.join "."


clear : Model -> Model
clear model =
    initFromCard model.card


fromFloat : Float -> Model -> Model
fromFloat fl model =
    let
        int : Int
        int =
            floor fl

        decimal : Float
        decimal =
            (toFloat <| Basics.round (1000 * (fl - toFloat int)))
                / 1000
    in
    { card = model.card
    , fieldInt = int
    , fieldDecimal =
        floor (decimal * toFloat (10 ^ -(floor <| logBase 10 decimal)))
    , decimalMode = False
    , calculation = None
    }


computeField : Model -> ( Model, Float )
computeField model =
    ( { model
        | fieldInt = 0
        , fieldDecimal = 0
      }
    , fieldToFloat model
    )


setCalculation : (Float -> Calculation) -> Model -> Model
setCalculation calcCtor model =
    let
        ( newModel, fl ) =
            computeField model
    in
    { newModel | calculation = calcCtor fl }


fieldToFloat : Model -> Float
fieldToFloat model =
    toFloat model.fieldInt + fieldDecimalToFloat model


fieldDecimalToFloat : Model -> Float
fieldDecimalToFloat model =
    let
        fdfl : Float
        fdfl =
            toFloat model.fieldDecimal
    in
    fdfl / toFloat (10 ^ ((floor <| logBase 10 fdfl) + 1))


type Calculation
    = None
    | Multiply Float
    | Divide Float
    | Add Float
    | Subtract Float


type OperationButton
    = Multiplication
    | Division
    | Addition
    | Subtraction


operationButtonToString : OperationButton -> String
operationButtonToString ob =
    case ob of
        Multiplication ->
            "x"

        Division ->
            "/"

        Addition ->
            "+"

        Subtraction ->
            "-"


type Msg
    = NumberInput Int
    | OperationClicked OperationButton
    | EqualsClicked
    | DecimalClicked
    | ClearClicked
    | SignFlipClicked


init : Session -> Model
init session =
    session.windowSize
        |> Size.center
        |> Position.subtractFromX (width / 2)
        |> Position.subtractFromY (height / 2)
        |> Card.initFromPosition
        |> initFromCard


initFromCard : Card.Model -> Model
initFromCard cardModel =
    { card = cardModel
    , fieldInt = 0
    , fieldDecimal = 0
    , decimalMode = False
    , calculation = None
    }


mapCard : (Card.Model -> Card.Model) -> Model -> Model
mapCard f model =
    { model | card = f model.card }



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        NumberInput int ->
            if model.decimalMode then
                if 10000 > model.fieldDecimal then
                    { model
                        | fieldDecimal =
                            model.fieldDecimal * 10 + int
                    }

                else
                    model

            else
                { model
                    | fieldInt =
                        model.fieldInt * 10 + int
                }

        OperationClicked Multiplication ->
            setCalculation Multiply model
                |> turnOffDecimalMode

        OperationClicked Division ->
            setCalculation Divide model
                |> turnOffDecimalMode

        OperationClicked Addition ->
            setCalculation Add model
                |> turnOffDecimalMode

        OperationClicked Subtraction ->
            setCalculation Subtract model
                |> turnOffDecimalMode

        EqualsClicked ->
            case model.calculation of
                None ->
                    model

                Multiply fl ->
                    fromFloat
                        (fl * fieldToFloat model)
                        model

                Divide fl ->
                    fromFloat
                        (fl / fieldToFloat model)
                        model

                Add fl ->
                    fromFloat
                        (fl + fieldToFloat model)
                        model

                Subtract fl ->
                    fromFloat
                        (fl - fieldToFloat model)
                        model

        DecimalClicked ->
            { model | decimalMode = True }

        ClearClicked ->
            clear model

        SignFlipClicked ->
            flipSign model



-- STYLE --


cardStyle : Model -> Style
cardStyle _ =
    [ Css.width (px width) ]
        |> Css.batch


width : Float
width =
    Units.size7


height : Float
height =
    568



-- VIEW --


title : Model -> String
title _ =
    "calculator"


view : Model -> List (Html Msg)
view model =
    [ Card.body
        [ Grid.row
            [ marginBottom (px Units.size1) ]
            [ Grid.column
                []
                [ field model
                ]
            ]
        , Grid.row
            [ marginBottom (px Units.size0) ]
            [ Grid.column
                [ marginRight (px Units.size0) ]
                [ clearButton ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ flipSignButton ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ decimalButton ]
            , Grid.column
                []
                [ operationButton Division ]
            ]
        , Grid.row
            [ marginBottom (px Units.size0) ]
            [ Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 7 ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 8 ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 9 ]
            , Grid.column
                []
                [ operationButton Multiplication ]
            ]
        , Grid.row
            [ marginBottom (px Units.size0) ]
            [ Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 4 ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 5 ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 6 ]
            , Grid.column
                []
                [ operationButton Subtraction ]
            ]
        , Grid.row
            [ marginBottom (px Units.size0) ]
            [ Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 1 ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 2 ]
            , Grid.column
                [ marginRight (px Units.size0) ]
                [ numberButton 3 ]
            , Grid.column
                []
                [ operationButton Addition ]
            ]
        , Grid.row
            [ marginBottom (px Units.size0) ]
            [ Grid.column
                [ flex none
                , Css.width (pct 75)
                ]
                [ numberButton 0 ]
            , Grid.column
                [ flex none
                , Css.width (pct 25)
                , paddingLeft (px Units.size0)
                ]
                [ equalsButton ]
            ]
        ]
    ]


clearButton : Html Msg
clearButton =
    button
        ClearClicked
        "c"


flipSignButton : Html Msg
flipSignButton =
    button
        SignFlipClicked
        "+/-"


equalsButton : Html Msg
equalsButton =
    button
        EqualsClicked
        "="


decimalButton : Html Msg
decimalButton =
    button
        DecimalClicked
        "."


operationButton : OperationButton -> Html Msg
operationButton ob =
    button
        (OperationClicked ob)
        (operationButtonToString ob)


numberButton : Int -> Html Msg
numberButton n =
    button
        (NumberInput n)
        (String.fromInt n)


button : msg -> String -> Html msg
button msg label =
    Button.view
        [ Attrs.css
            [ Button.styles
            , minWidth (px Units.size0)
            , flex (int 1)
            , padding zero
            ]
        , Events.onClick msg
        ]
        label


field : Model -> Html Msg
field model =
    Input.view
        [ textAlign right ]
        [ Attrs.value (fieldToString model) ]


encode : Model -> E.Value
encode model =
    [ ( "card", Card.encode model.card ) ]
        |> E.object


decoder : Decoder Model
decoder =
    Card.decoder
        |> D.field "card"
        |> D.map initFromCard
