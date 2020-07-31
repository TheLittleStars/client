module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Doc
import Html
import Json.Decode as Json
import Ports exposing (..)
import Types
import Url exposing (Url)



-- MODEL


type Model
    = TreeDocument Doc.Model


init : ( Json.Value, Doc.InitModel, Bool ) -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    Doc.init flags
        |> (\( dm, c ) -> ( TreeDocument dm, Cmd.map GotDocMsg c ))



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg title viewer =
            { title = title
            , body = List.map (Html.map toMsg) viewer
            }
    in
    case model of
        TreeDocument docModel ->
            viewPage TreeDocument GotDocMsg "Tree" [ Doc.view docModel ]



-- UPDATE


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotDocMsg Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ChangedUrl _, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink _, _ ) ->
            ( model, Cmd.none )

        ( GotDocMsg subMsg, TreeDocument docModel ) ->
            Doc.update subMsg docModel
                |> updateWith TreeDocument GotDocMsg


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- MAIN


main : Program ( Json.Value, Doc.InitModel, Bool ) Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , view = view
        , update = update
        , subscriptions =
            \m ->
                case m of
                    TreeDocument dm ->
                        Doc.subscriptions dm
                            |> Sub.map GotDocMsg
        }
