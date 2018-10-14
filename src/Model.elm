module Model exposing
    ( Model
    , fromFlags
    , mapSession
    , mapWindow
    , mapWindows
    , setTopWindow
    )

import Db exposing (Db)
import Flags exposing (Flags)
import Id exposing (Id)
import Random exposing (Seed)
import Session exposing (Session)
import Window exposing (Window)


type alias Model =
    { windows : Db Window.Model
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


mapWindows : (Db Window.Model -> Db Window.Model) -> Model -> Model
mapWindows f model =
    { model | windows = f model.windows }


mapWindow : Id -> (Window.Model -> Window.Model) -> Model -> Model
mapWindow id f model =
    { model | windows = Db.mapItem id f model.windows }


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }


setTopWindow : Id -> Model -> Model
setTopWindow id model =
    { model | topWindow = Just id }
