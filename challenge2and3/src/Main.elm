module Main exposing (main)

import Browser
import Browser.Events exposing (onKeyPress)
import Color
import Html exposing (Html, header, main_, p, text)
import Json.Decode as Decode
import Random
import Time
import TypedSvg exposing (circle, svg, text_)
import TypedSvg.Attributes exposing (cx, cy, fill, preserveAspectRatio, r, viewBox, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Align(..), MeetOrSlice(..), Paint(..), Scale(..), num)



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { points : List Point
    , paused : Bool
    }


type alias Point =
    ( X, Y )


type alias X =
    Float


type alias Y =
    Float


init : () -> ( Model, Cmd Msg )
init _ =
    ( emptyModel
    , Cmd.none
    )


emptyModel : Model
emptyModel =
    { points = []
    , paused = False
    }



-- Update


type Msg
    = Tick Time.Posix
    | NewPoint ( X, Y )
    | Pause Bool
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( model
            , Random.generate NewPoint position
            )

        NewPoint ( x, y ) ->
            ( { model | points = model.points ++ [ ( x, y ) ] }
            , Cmd.none
            )

        Pause bool ->
            ( { model | paused = bool }
            , Cmd.none
            )

        Reset ->
            ( emptyModel, Cmd.none )


position : Random.Generator ( X, Y )
position =
    Random.pair xPosition yPosition


xPosition : Random.Generator X
xPosition =
    Random.float 0 200


yPosition : Random.Generator Y
yPosition =
    Random.float 0 100



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subs =
            onKeyPressed model.paused
                :: (if model.paused then
                        []

                    else
                        [ Time.every 1000 Tick ]
                   )
    in
    Sub.batch subs


onKeyPressed : Bool -> Sub Msg
onKeyPressed pausedStatus =
    onKeyPress
        (keyDecoder
            |> Decode.andThen
                (\key ->
                    case key of
                        " " ->
                            Decode.succeed <| Pause (not pausedStatus)

                        "r" ->
                            Decode.succeed <| Reset

                        _ ->
                            Decode.fail ""
                )
        )


keyDecoder : Decode.Decoder String
keyDecoder =
    Decode.field "key" Decode.string



-- View


circleRadius : Float
circleRadius =
    2.0


view : Model -> Html Msg
view model =
    main_ []
        [ header []
            [ p [] [ text "Press the 'Space' key to pause. Press the 'r' key to reset." ]
            ]
        , svg [ viewBox 0 0 200 100, preserveAspectRatio (Align ScaleMid ScaleMid) Meet ]
            (List.map
                (\( x, y ) -> viewCircle circleRadius x y)
                model.points
                ++ (if model.paused then
                        [ text_ [ x (num 90), y (num 50) ] [ text "Paused" ] ]

                    else
                        []
                   )
            )
        ]


viewCircle : Float -> Float -> Float -> Svg Msg
viewCircle radius xLocation yLocation =
    circle
        [ cx (num xLocation)
        , cy (num yLocation)
        , r (num radius)
        , fill <| Paint Color.blue
        ]
        []
