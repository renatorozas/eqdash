module Eqdash (..) where

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (class)
import List.Extra
import Maybe exposing (..)

app : StartApp.App Model
app =
  StartApp.start
  { init = init
  , update = update
  , view = view
  , inputs = [incomingEvents]
  }

main : Signal Html
main =
  app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks

-- MODEL

type alias LatLng =
  { latitude : String
  , longitude : String
  }

type alias Event =
  { title : String
  , time : String
  , magnitude : String
  , location : LatLng
  , id : String
  }

type alias Model =
  List Event

init : ( Model, Effects Action )
init =
  ( [], Effects.none )

-- ACTIONS

type Action
  = SetEvents Model

-- UPDATE

update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    SetEvents events ->
      ( events, Effects.none )

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  latestEvents address model

latestEvents : Signal.Address Action -> Model -> Html
latestEvents address model =
  div
    []
    [
      h5
        []
        [ text "Latest Event" ]
      , eventsTable address model
    ]

eventsTable : Signal.Address Action -> Model -> Html
eventsTable address model =
  table
    []
    [
      eventTableHead
    , eventTableBody address model
    ]

eventTableHead : Html
eventTableHead =
  thead
    []
    [
      tr
        []
        [
          th [] [ text "Where" ],
          th [] [ text "When" ],
          th [] [ text "Magnitude" ]
        ]
    ]

eventTableBody : Signal.Address Action -> Model -> Html
eventTableBody address model =
  tbody
    []
    (List.map (eventRow address) model)

eventRow : Signal.Address Action -> Event -> Html
eventRow address event =
  tr
    []
    [
      td
        []
        [ text event.title ]
    , td
        []
        [ text event.time ]
    , td
        []
        [ text event.magnitude ]
    ]

-- SIGNALS

port eventList : Signal Model

incomingEvents : Signal Action
incomingEvents =
  Signal.map SetEvents eventList
