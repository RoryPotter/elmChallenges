module Main exposing (main)

import Browser
import Browser.Events exposing (onMouseMove)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (classList, id)
import Json.Decode as Decode



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
    = Side Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Side fraction ->
            let
                newModel =
                    if fraction > 0.5 then
                        Right

                    else
                        Left
            in
            ( newModel
            , Cmd.none
            )



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
    onMouseMove (Decode.map Side decodeFraction)


decodeFraction : Decode.Decoder Float
decodeFraction =
    Decode.map2 (/)
        (Decode.field "pageX" Decode.float)
        (Decode.at [ "currentTarget", "defaultView", "innerWidth" ] Decode.float)



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
