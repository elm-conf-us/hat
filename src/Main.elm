module Main exposing (..)

import Element
import Element.Attributes as Attributes
import Html exposing (Html)
import Keyboard
import Random.Pcg as Random exposing (Generator)
import Style exposing (StyleSheet)
import Style.Font as Font
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


type Styles
    = NoStyle
    | Container
    | MainText


sheet : StyleSheet Styles variation
sheet =
    Style.styleSheet
        [ Style.style NoStyle []
        , Style.style Container
            [ Font.typeface
                [ Font.importUrl
                    { name = "Roboto Condensed"
                    , url = "https://fonts.googleapis.com/css?family=Roboto+Condensed"
                    }
                , Font.sansSerif
                ]
            , Font.lineHeight 1.61803
            ]
        , Style.style MainText
            [ Font.size 100 ]
        ]


view : Model -> Html Msg
view model =
    Element.layout
        sheet
        (Element.column Container
            [ Attributes.center
            , Attributes.width (Attributes.percent 100)
            , Attributes.verticalCenter
            , Attributes.inlineStyle [ ( "height", "100vh" ) ]
            ]
            [ Element.paragraph MainText
                []
                [ case model of
                    Empty ->
                        Element.text "Loading names..."

                    Running Nothing _ ->
                        Element.text "Let's go!"

                    Running (Just name) _ ->
                        Element.text name
                ]
            ]
        )



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
