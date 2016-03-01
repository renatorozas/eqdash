// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import MarkerClusterer from "node-js-marker-clusterer"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import GoogleMap from "./google_maps"

let elmDiv = document.getElementById("elm-main")
  , initialState = { eventList: [] }
  , elmApp = Elm.embed(Elm.Eqdash, elmDiv, initialState)
  , channel = socket.channel('events:index', {})
  , map = new GoogleMap("map")
  , infoWindowContent = event => {
    return '<div class="info-window-content">'+
      '<h6>Event information</h6>'+
      '<ul>'+
        '<li><strong>Where:</strong> ' + event.title + '</li>'+
        '<li><strong>When:</strong> ' + event.time + '</li>'+
        '<li><strong>Magnitude:</strong> ' + event.magnitude + ')</li>'+
      '</ul>'+
    '</div>'
  }

channel.join().receive('ok', data => {
  console.log("Subscribed successfully", data)

  let events = data.events

  elmApp.ports.eventList.send(events)

  events.forEach(event => {
    map.addMarker(event.id, {
      animation: google.maps.Animation.DROP,
      position: {
        lat: parseFloat(event.location.latitude),
        lng: parseFloat(event.location.longitude)
      },
      title: event.title
    })

    map.addInfoWindow(event.id, { content: infoWindowContent(event) })
  })
}).receive("error", data => {
  console.log("Unable to subscribe", data)
})

channel.on("events_updates", data => {
  console.log("Events updates: ", data)

  let events = data.events

  events.forEach(event => {
    map.upsertMarker(event.id, {
      animation: google.maps.Animation.DROP,
      position: {
        lat: parseFloat(event.location.latitude),
        lng: parseFloat(event.location.longitude)
      },
      title: event.title
    })

    map.upsertInfoWindow(event.id, {
      content: infoWindowContent(event)
    })
  })

  elmApp.ports.eventList.send(events)
})
