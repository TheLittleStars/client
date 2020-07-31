module Main exposing (main)

import Browser
import Doc
import Json.Decode as Json
import Ports exposing (..)
import Time
import Types exposing (Msg(..))


main : Program ( Json.Value, Doc.InitModel, Bool ) Doc.Model Msg
main =
    Browser.element
        { init = Doc.init
        , view = Doc.view
        , update = Doc.update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Doc.Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveMsg Port LogErr
        , Time.every (15 * 1000) TimeUpdate
        , Time.every (10 * 1000) (\_ -> Sync)
        ]
