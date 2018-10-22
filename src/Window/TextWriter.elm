module Window.TextWriter exposing
    ( Msg
    , update
    , view
    )

import Css exposing (..)
import Data.Window as Window
import Data.Window.TextWriter exposing (Model)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Id exposing (Id)
import Model as Main
import Session exposing (Session)
import Style.Units as Units
import View.Button as Button
import View.Card as Card
import View.Input as Input


type Msg
    = TextareaUpdated String
    | FileNameUpdated String
    | SaveClicked



-- UPDATE --


update : Msg -> Main.Model -> Id -> Model -> ( Main.Model, Model )
update msg mainModel id model =
    case msg of
        TextareaUpdated str ->
            ( mainModel
            , { model | text = str }
            )

        FileNameUpdated str ->
            ( mainModel
            , { model | fileName = str }
            )

        SaveClicked ->
            ( Main.saveWindow
                model.fileName
                ( id, Window.TextWriter model )
                mainModel
            , model
            )



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Card.body
        [ Grid.row
            [ marginBottom (px Units.size0) ]
            [ Grid.column
                [ paddingRight (px Units.size0) ]
                [ fileNameField model ]
            , Grid.column
                [ flex none ]
                [ saveButton ]
            ]
        , Grid.row
            []
            [ Grid.column
                []
                [ textView model ]
            ]
        ]
    ]


fileNameField : Model -> Html Msg
fileNameField model =
    Input.view
        []
        [ Attrs.value model.fileName
        , Events.onInput FileNameUpdated
        ]


saveButton : Html Msg
saveButton =
    Button.view
        [ Attrs.css [ Button.styles ]
        , Events.onClick SaveClicked
        ]
        "save"


textView : Model -> Html Msg
textView model =
    Html.textarea
        textareaAttrs
        [ Html.text model.text ]


textareaAttrs : List (Attribute Msg)
textareaAttrs =
    [ Events.onInput TextareaUpdated ]
        ++ Input.textareaAttrs
            [ minHeight (px Units.size9) ]
