module Model exposing
    ( Model
    , encode
    , fromFlags
    , initCalculatorWindow
    , initTextWriterWindow
    , initTungstenWindow
    , initWelcomeWindow
    , mapSession
    , mapWindow
    , mapWindows
    , openSavedWindow
    , removeWindow
    , saveWindow
    , setTopWindow
    , setWindow
    , windows
    )

import Data.Window as Window exposing (Window)
import Data.Window.TextWriter as TextWriter
import Data.Window.Welcome as Welcome
import Db exposing (Db)
import Dict exposing (Dict)
import Flags exposing (Flags)
import Id exposing (Id)
import Json.Encode as E
import List.Extra
import Random exposing (Seed)
import Session exposing (Session)
import Window.Calculator as Calculator
import Window.Tungsten as Tungsten


type alias Model =
    { windows : Db Window
    , windowOrder : List Id
    , savedWindows : Dict String ( Id, Window )
    , topWindow : Maybe Id
    , session : Session
    }


fromFlags : Flags -> Model
fromFlags flags =
    { windows = flags.windows
    , windowOrder = []
    , savedWindows = flags.savedWindows
    , topWindow = Nothing
    , session =
        { seed = flags.seed
        , windowSize = flags.windowSize
        }
    }


windows : Model -> List ( Id, Window )
windows model =
    model.windows
        |> Db.toList
        |> List.sortBy (windowOrder model)


windowOrder : Model -> ( Id, Window ) -> Int
windowOrder model ( id, window ) =
    case List.Extra.elemIndex id model.windowOrder of
        Just order ->
            order

        Nothing ->
            9001


mapWindows : (Db Window -> Db Window) -> Model -> Model
mapWindows f model =
    { model | windows = f model.windows }


mapWindow : Id -> (Window -> Window) -> Model -> Model
mapWindow id f model =
    { model | windows = Db.mapItem id f model.windows }


setWindow : Id -> Window -> Model -> Model
setWindow id window model =
    { model | windows = Db.insert id window model.windows }


saveWindow : String -> ( Id, Window ) -> Model -> Model
saveWindow fileName window model =
    { model
        | savedWindows =
            Dict.insert
                fileName
                window
                model.savedWindows
    }


openSavedWindow : String -> Model -> Model
openSavedWindow fileName model =
    case Dict.get fileName model.savedWindows of
        Just ( id, window ) ->
            model
                |> setWindow id window
                |> setTopWindow id

        Nothing ->
            model


removeWindow : Id -> Model -> Model
removeWindow id model =
    { model
        | windows = Db.remove id model.windows
        , windowOrder = List.filter ((/=) id) model.windowOrder
    }


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }


setTopWindow : Id -> Model -> Model
setTopWindow id model =
    { model
        | topWindow = Just id
        , windowOrder =
            id :: List.filter ((/=) id) model.windowOrder
    }


initWelcomeWindow : Model -> Model
initWelcomeWindow model =
    initWelcomeWindowHelper model.session model
        |> setTopWindow Welcome.id


initWelcomeWindowHelper : Session -> Model -> Model
initWelcomeWindowHelper session =
    session
        |> Welcome.init
        |> Window.Welcome
        |> Db.insert Welcome.id
        |> mapWindows


initTextWriterWindow : Model -> Model
initTextWriterWindow model =
    let
        ( id, newSeed ) =
            Random.step Id.generator model.session.seed
    in
    model
        |> initTextWriterWindowHelper id model.session
        |> mapSession (Session.setSeed newSeed)
        |> setTopWindow id


initTextWriterWindowHelper : Id -> Session -> Model -> Model
initTextWriterWindowHelper id session =
    session
        |> TextWriter.init
        |> Window.TextWriter
        |> Db.insert id
        |> mapWindows


initTungstenWindow : Model -> Model
initTungstenWindow model =
    let
        ( id, newSeed ) =
            Random.step Id.generator model.session.seed
    in
    model
        |> initTungstenWindowHelper id model.session
        |> mapSession (Session.setSeed newSeed)
        |> setTopWindow id


initTungstenWindowHelper : Id -> Session -> Model -> Model
initTungstenWindowHelper id session =
    session
        |> Tungsten.init
        |> Window.Tungsten
        |> Db.insert id
        |> mapWindows


initCalculatorWindow : Model -> Model
initCalculatorWindow model =
    let
        ( id, newSeed ) =
            Random.step Id.generator model.session.seed
    in
    model
        |> initCalculatorWindowHelper id model.session
        |> mapSession (Session.setSeed newSeed)
        |> setTopWindow id


initCalculatorWindowHelper : Id -> Session -> Model -> Model
initCalculatorWindowHelper id session =
    session
        |> Calculator.init
        |> Window.Calculator
        |> Db.insert id
        |> mapWindows


encode : Model -> E.Value
encode model =
    [ ( "windows", encodeWindows model.windows )
    , ( "saved-windows", encodeSavedWindows model.savedWindows )
    ]
        |> E.object


encodeSavedWindows : Dict String ( Id, Window ) -> E.Value
encodeSavedWindows savedWindows_ =
    savedWindows_
        |> Dict.toList
        |> E.list encodeSavedWindow


encodeSavedWindow : ( String, ( Id, Window ) ) -> E.Value
encodeSavedWindow ( fileName, window ) =
    [ ( "file-name", E.string fileName )
    , ( "data", encodeWindow window )
    ]
        |> E.object


encodeWindows : Db Window -> E.Value
encodeWindows windows_ =
    windows_
        |> Db.toList
        |> E.list encodeWindow


encodeWindow : ( Id, Window ) -> E.Value
encodeWindow ( id, window ) =
    [ ( "id", Id.encode id )
    , ( "data", Window.encode window )
    ]
        |> E.object
