module HomePage exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Translation exposing (TranslationId(..), langFromString, languageName, timeDistInWords, tr)



-- MODEL


type alias Model =
    { documents : List Document
    , language : Translation.Language
    }


type alias Document =
    { name : String
    , state : DocState
    }


type DocState
    = Local


init : Model
init =
    { documents = [], language = langFromString "en" }



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text "This is the home page" ]



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
