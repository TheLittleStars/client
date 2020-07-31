module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Doc
import HomePage
import Html
import Json.Decode as Json
import Ports exposing (..)
import Types
import Url exposing (Url)



-- MODEL


type Model
    = HomePage HomePage.Model
    | TreeDocument Doc.Model


init : ( Json.Value, Doc.InitModel, Bool ) -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    case url.path of
        "/" ->
            ( HomePage HomePage.init, Cmd.none )

        path ->
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
        HomePage homeModel ->
            viewPage HomePage GotHomeMsg "Home" [ HomePage.view homeModel ]

        TreeDocument docModel ->
            viewPage TreeDocument GotDocMsg "Tree" [ Doc.view docModel ]



-- UPDATE


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMsg HomePage.Msg
    | GotDocMsg Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ChangedUrl _, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink _, _ ) ->
            ( model, Cmd.none )

        ( GotHomeMsg subMsg, HomePage docModel ) ->
            HomePage.update subMsg docModel
                |> updateWith HomePage GotHomeMsg

        ( GotDocMsg subMsg, TreeDocument docModel ) ->
            Doc.update subMsg docModel
                |> updateWith TreeDocument GotDocMsg

        ( _, _ ) ->
            ( model, Cmd.none )


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
                    HomePage _ ->
                        Sub.none

                    TreeDocument dm ->
                        Doc.subscriptions dm
                            |> Sub.map GotDocMsg
        }
