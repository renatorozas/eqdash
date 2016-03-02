module Eqdash (..) where

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href)
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
  | ShowEventOnMap Event
  | TaskDone ()

-- UPDATE

update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    SetEvents events ->
      ( events, Effects.none )
    ShowEventOnMap event ->
      let
        fx =
          Signal.send showEventOnMapMailbox.address event.id
            |> Effects.task
            |> Effects.map TaskDone
      in
        ( model, fx )
    TaskDone () ->
      ( model, Effects.none )

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  latestEvents address model

latestEvents : Signal.Address Action -> Model -> Html
latestEvents address model =
  div
    [ class "col-md-12"
    ]
    [
      h3
        []
        [ text "Latest Event" ]
      , eventsTable address model
    ]

eventsTable : Signal.Address Action -> Model -> Html
eventsTable address model =
  div
    [ class "table-responsive" ]
    [
      table
        [ class "table"
        ]
        [
          eventTableHead
        , eventTableBody address model
        ]
    ]

eventTableHead : Html
eventTableHead =
  thead
    []
    [
      tr
        []
        [ th [] [ text "Where" ]
        , th [ class "hidden-sm-down" ] [ text "When" ]
        , th [ class "hidden-sm-down" ] [ text "Magnitude" ]
        , th [] []
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
        [ class "hidden-sm-down" ]
        [ text event.time ]
    , td
        [ class "hidden-sm-down" ]
        [ text event.magnitude ]
    , td
        []
        [
          a
            [
              class "btn btn-link btn-sm"
            , href "#"
            , onClick address (ShowEventOnMap event)
            ]
            [ text "Show on map"
            ]
        ]
    ]

-- MAILBOXES

showEventOnMapMailbox : Signal.Mailbox String
showEventOnMapMailbox =
  Signal.mailbox ""

-- PORTS

-- outgoing
port eventToShowOnMap : Signal String
port eventToShowOnMap =
  showEventOnMapMailbox.signal

-- incoming

port eventList : Signal Model

incomingEvents : Signal Action
incomingEvents =
  Signal.map SetEvents eventList
