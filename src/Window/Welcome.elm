module Window.Welcome exposing
    ( Msg
    , update
    , view
    )

import Css exposing (..)
import Data.Position as Position
import Data.Size as Size exposing (Size)
import Data.Window as Window exposing (Window)
import Data.Window.Welcome as Welcome exposing (Model)
import Db
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Id exposing (Id)
import List.Extra as LE
import Model as Main
import Session exposing (Session)
import Style.Units as Units
import View.Button as Button
import View.Card as Card



-- TYPES --


type Msg
    = OptionChosen ProgramOption


type ProgramOption
    = TextWriter
    | Tungsten
    | Calculator


programOptionToString : ProgramOption -> String
programOptionToString option =
    case option of
        TextWriter ->
            "text writer"

        Tungsten ->
            "tungsten web browser"

        Calculator ->
            "calculator"



-- UPDATE --


update : Msg -> Main.Model -> Model -> ( Main.Model, Model )
update msg mainModel model =
    case msg of
        OptionChosen TextWriter ->
            ( mainModel
                |> Main.initTextWriterWindow
                |> Main.removeWindow Welcome.id
            , model
            )

        OptionChosen Tungsten ->
            ( mainModel
                |> Main.initTungstenWindow
                |> Main.removeWindow Welcome.id
            , model
            )

        OptionChosen Calculator ->
            ( mainModel
                |> Main.initCalculatorWindow
                |> Main.removeWindow Welcome.id
            , model
            )



-- VIEW --


view : List (Html Msg)
view =
    [ Card.body bodyContent ]


bodyContent : List (Html Msg)
bodyContent =
    Grid.row
        [ marginBottom (px Units.size1) ]
        [ Grid.column
            []
            [ introMessage ]
        ]
        :: windowButtons


introMessage : Html Msg
introMessage =
    Html.p
        []
        [ Html.text
            """
            what program would you like to open?
            """
        ]


windowButtons : List (Html Msg)
windowButtons =
    [ ( TextWriter
      , """
        write documents and take notes
        """
      )
    , ( Tungsten
      , """
        visit your favorite websites
        """
      )
    , ( Calculator
      , """
        do math
        """
      )
    ]
        |> List.map programOptionContainer


programOptionContainer : ( ProgramOption, String ) -> Html Msg
programOptionContainer ( option, description ) =
    Grid.row
        [ marginTop (px Units.size1) ]
        [ Grid.column
            [ flex none
            , marginRight (px Units.size1)
            ]
            [ optionButtonView option ]
        , Grid.column
            []
            [ descriptionView description ]
        ]


optionButtonView : ProgramOption -> Html Msg
optionButtonView programOption =
    Button.view
        [ Attrs.css
            [ Button.styles
            , minWidth (px Units.size7)
            ]
        , Events.onClick (OptionChosen programOption)
        ]
        (programOptionToString programOption)


descriptionView : String -> Html Msg
descriptionView dsc =
    Html.p
        [ Attrs.css [ lineHeight (px Units.size4) ] ]
        [ Html.text dsc ]
