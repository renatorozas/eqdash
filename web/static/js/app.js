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

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

class GoogleMap {
  constructor(elementId) {
    this.refs = {}
    this.map = new google.maps.Map(document.getElementById(elementId), {
      zoom: 2,
      mapTypeId: google.maps.MapTypeId.HYBRID,
      mapTypeControl: false,
      streetViewControl: false,
      scrollwheel: false
    })

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        let initialLocation = new google.maps.LatLng(
          position.coords.latitude,
          position.coords.longitude
        )
        this.map.setCenter(initialLocation)
      })
    } else {
      this.map.setCenter(new google.maps.LatLng(47.6149942, -122.4759899))
    }
  }
  addMarker(id, options) {
    let marker = new google.maps.Marker(
      Object.assign({ map: this.map }, options)
    )

    this.refs[id] = { marker: marker }

    marker
  }
  addInfoWindow(markerId, options) {
    let marker = this.refs[markerId].marker
      , infoWindow = new google.maps.InfoWindow(options);

    marker.addListener('click', () => {
      infoWindow.open(this.map, marker);
    });

    this.refs[markerId].infoWindow = infoWindow
  }
}

var refs = {}
let map = new GoogleMap('map')

let elmDiv = document.getElementById("elm-main")
  , initialState = { eventList: [] }
  , elmApp = Elm.embed(Elm.Eqdash, elmDiv, initialState)
  , channel = socket.channel('events:index', {})

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

    let infoWindowContent = '<div class="info-window-content">'+
      '<h6>Event information</h6>'+
      '<ul>'+
        '<li><strong>Where:</strong> ' + event.title + '</li>'+
        '<li><strong>When:</strong> ' + event.time + '</li>'+
        '<li><strong>Magnitude:</strong> ' + event.magnitude + ')</li>'+
      '</ul>'+
    '</div>';

    map.addInfoWindow(event.id, { content: infoWindowContent })
  })
}).receive("error", data => {
  console.log("Unable to subscribe", data)
})
