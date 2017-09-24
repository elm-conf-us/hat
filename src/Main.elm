module Main exposing (..)

import Html exposing (Html)
import Html.Events as Events
import Keyboard
import Random.Pcg as Random exposing (Generator)
import Task


-- MODEL


type Model
    = Empty
    | Running (Maybe String) (List String)


init : ( Model, Cmd Msg )
init =
    ( Empty
    , loadNames
    )



-- UPDATE


type Msg
    = NewNames (List String)
    | Next
    | Selected (Maybe String)


loadNames : Cmd Msg
loadNames =
    -- TODO faaaake but will get us there for data modeling purposes
    Task.succeed [ "Alice", "Bob", "Clara", "Dave", "Elizabeth", "Frank", "Grace", "Herman", "Isabelle", "James", "Kyrie" ]
        |> Task.perform NewNames


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewNames names ->
            ( Running Nothing names
            , Cmd.none
            )

        Next ->
            case model of
                Empty ->
                    ( model, Cmd.none )

                Running _ generator ->
                    ( model
                    , Random.generate Selected (Random.sample generator)
                    )

        Selected result ->
            case model of
                Empty ->
                    ( model, Cmd.none )

                Running _ generator ->
                    ( Running result generator
                    , Cmd.none
                    )



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Empty ->
            Html.div []
                [ Html.text "Loading names" ]

        Running Nothing _ ->
            Html.div []
                [ Html.text "Let's get started!" ]

        Running (Just name) _ ->
            Html.div []
                [ Html.text name ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions =
            \_ ->
                Keyboard.presses (\_ -> Next)
        }
