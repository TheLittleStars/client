module Page.Doc exposing (Model, Msg, init, update, view)

import Doc
import Html exposing (..)
import Ports exposing (sendOut)
import Task
import Types exposing (OutgoingMsg(..))



-- MODEL


type alias Model =
    Status Doc.Model


type Status a
    = Loading
    | Loaded a
    | Failed


init : ( Doc.InitModel, Bool ) -> Maybe String -> ( Model, Cmd Msg )
init docInit docName_ =
    case docName_ of
        Nothing ->
            let
                ( doc, cmd ) =
                    Doc.init docInit
            in
            ( Loaded doc, Cmd.none )

        Just docName ->
            ( Loading, fetchDocument docName )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    case model of
        Loading ->
            { title = "", content = div [] [] }

        Loaded doc ->
            { title = "Doc name goes here"
            , content = Doc.view doc |> Html.map GotDocMsg
            }

        Failed ->
            { title = "Error...", content = div [] [ text "Error :(" ] }



-- UPDATE


type Msg
    = CompletedLoadDoc Doc.Model
    | GotDocMsg Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadDoc docModel ->
            ( Loaded docModel, Cmd.none )

        GotDocMsg subMsg ->
            case model of
                Loaded docModel ->
                    let
                        ( newDoc, subCmd ) =
                            Doc.update subMsg docModel
                    in
                    ( Loaded newDoc, Cmd.map GotDocMsg subCmd )

                _ ->
                    ( model, Cmd.none )
