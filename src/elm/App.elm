module App exposing (main)

import Browser
import Json.Decode as Json
import Main
import Types exposing (Msg)


main : Program ( Json.Value, Main.InitModel, Bool ) Main.Model Msg
main =
    Browser.element
        { init = Main.init
        , view = Main.view
        , update = Main.update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Main.Model -> Sub Msg
subscriptions model =
    Sub.none



{- Sub.batch
   [ receiveMsg Port LogErr
   , Time.every (15 * 1000) TimeUpdate
   , Time.every (10 * 1000) (\_ -> Sync)
   ]
-}
