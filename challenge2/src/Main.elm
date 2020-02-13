module Main exposing (main)

import Browser
import Color
import Html exposing (Html)
import Random
import Time
import TypedSvg exposing (circle, svg)
import TypedSvg.Attributes exposing (cx, cy, fill, preserveAspectRatio, r, viewBox)
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
    }


type alias Point =
    ( X, Y )


type alias X =
    Float


type alias Y =
    Float


init : () -> ( Model, Cmd Msg )
init _ =
    ( { points = []
      }
    , Cmd.none
    )



-- Update


type Msg
    = Tick Time.Posix
    | NewPoint ( X, Y )


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
subscriptions _ =
    Time.every 2000 Tick



-- View


circleRadius : Float
circleRadius =
    2.0


view : Model -> Html Msg
view model =
    svg [ viewBox 0 0 200 100, preserveAspectRatio (Align ScaleMid ScaleMid) Meet ]
        (List.map
            (\( x, y ) -> viewCircle circleRadius x y)
            model.points
        )


viewCircle : Float -> Float -> Float -> Svg Msg
viewCircle radius xLocation yLocation =
    circle
        [ cx (num xLocation)
        , cy (num yLocation)
        , r (num radius)
        , fill <| Paint Color.blue
        ]
        []
