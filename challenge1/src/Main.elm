module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (classList, id)



-- Model


type alias Model =
    Side


type Side
    = Right
    | Left


init : () -> ( Model, Cmd Msg )
init _ =
    ( Right, Cmd.none )



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    let
        sideText =
            case model of
                Right ->
                    "Right"

                Left ->
                    "Left"
    in
    div
        [ id "app"
        , classList
            [ ( "right", model == Right )
            , ( "left", model == Left )
            ]
        ]
        [ h1 [] [ text sideText ] ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
