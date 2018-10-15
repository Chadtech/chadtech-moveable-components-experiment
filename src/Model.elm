module Model exposing
    ( Model
    , fromFlags
    , initWelcomeWindow
    , mapSession
    , mapWindow
    , mapWindows
    , removeWindow
    , setTopWindow
    )

import Data.Window as Window exposing (Window)
import Db exposing (Db)
import Flags exposing (Flags)
import Id exposing (Id)
import Random exposing (Seed)
import Session exposing (Session)
import Window.Welcome as Welcome


type alias Model =
    { windows : Db Window
    , topWindow : Maybe Id
    , session : Session
    }


fromFlags : Flags -> Model
fromFlags flags =
    { windows = Db.empty
    , topWindow = Nothing
    , session =
        { seed = flags.seed
        , windowSize = flags.windowSize
        }
    }


mapWindows : (Db Window -> Db Window) -> Model -> Model
mapWindows f model =
    { model | windows = f model.windows }


mapWindow : Id -> (Window -> Window) -> Model -> Model
mapWindow id f model =
    { model | windows = Db.mapItem id f model.windows }


removeWindow : Id -> Model -> Model
removeWindow id model =
    { model | windows = Db.remove id model.windows }


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }


setTopWindow : Id -> Model -> Model
setTopWindow id model =
    { model | topWindow = Just id }


initWelcomeWindow : Model -> Model
initWelcomeWindow model =
    initWelcomeWindowHelper model.session model


initWelcomeWindowHelper : Session -> Model -> Model
initWelcomeWindowHelper session =
    session
        |> Welcome.init
        |> Window.Welcome
        |> Db.insert Welcome.id
        |> mapWindows
