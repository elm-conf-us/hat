module Main exposing (..)

import Element
import Element.Attributes as Attributes
import Html exposing (Html)
import Keyboard
import Names
import Random.Pcg as Random exposing (Generator)
import Style exposing (StyleSheet)
import Style.Font as Font


-- MODEL


type alias Model =
    { picked : Maybe String
    , remaining : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { picked = Nothing
      , remaining = Names.names
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Next
    | Selected (Maybe String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Next ->
            ( model
            , Random.generate Selected (Random.sample model.remaining)
            )

        Selected result ->
            ( { model
                | picked = result
                , remaining =
                    result
                        |> Maybe.map (\unwrapped -> List.filter ((/=) unwrapped) model.remaining)
                        |> Maybe.withDefault model.remaining
              }
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
                [ case model.picked of
                    Nothing ->
                        Element.text "Let's go!"

                    Just name ->
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
