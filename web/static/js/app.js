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

import socket from './socket'
import React from 'react'
import ReactDOM from 'react-dom'

class EventsIndex extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      events: [],
      new_events: [],
      updated_events: []
    };
  }
  componentWillMount() {
    // Now that you are connected, you can join channels with a topic:
    let channel = socket.channel('events:index', {})
    let self = this

    channel.on('events_updates', resp => {
      console.log('Events updates:', resp)

      self.setState({
        new_events: resp.new_events,
        updated_events: resp.updated_events
      });
    });

    channel.join().receive('ok', resp => {
      console.log('Subscribed successfully')

      self.setState({ events: resp.events });
    }).receive('error', resp => {
      console.log('Unable to Subscribe', resp);
    })
  }
  render() {
    return (
      <div>
        <EventsMap
          events={this.state.events}
          new_events={this.state.new_events}
          updated_events={this.state.updated_events}
        />
        <EventsList
          events={this.state.events}
          new_events={this.state.new_events}
          updated_events={this.state.updated_events}
        />
      </div>
    );
  }
}

class EventsMap extends React.Component {
  constructor(props) {
    super(props);
    this.state = { events: {} };
  }
  componentDidMount() {
    this.map = new google.maps.Map(document.getElementById('map-container'), {
      zoom: 2,
      mapTypeId: google.maps.MapTypeId.HYBRID,
      mapTypeControl: false,
      streetViewControl: false,
      scrollwheel: false
    });

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        this.map.setCenter({
          lat: position.coords.latitude,
          lng: position.coords.longitude
        });
      });
    } else {
      this.map.setCenter({
        lat: 47.6149942,
        lng: -122.4759899
      });
    }
  }
  componentWillReceiveProps(nextProps) {
    if (nextProps.updated_events && nextProps.updated_events.length > 0) {
      this.updateEvents(nextProps.updated_events);
    }

    if (nextProps.new_events) {
      this.addEvents(nextProps.new_events);
    }

    // FIXME: This is dirty!
    if (nextProps.events && Object.keys(this.state.events).length == 0) {
      this.addEvents(nextProps.events);
    }
  }
  render() {
    return (
      <div id="map-container"></div>
    );
  }
  addEvents(events) {
    events.forEach(event => {
      this.addEvent(event);
    });
  }
  updateEvents(events) {
    events.forEach(event => {
      this.updateEvent(event);
    });
  }

  addEvent(event) {
    let latLng = {
      lat: parseFloat(event.latitude),
      lng: parseFloat(event.longitude)
    };

    let marker = new google.maps.Marker({
      animation: google.maps.Animation.DROP,
      position: latLng,
      map: this.map,
      title: event.place
    });

    let infoWindow = new google.maps.InfoWindow({
      content: this.infoWindowContent(event)
    });

    let circle = new google.maps.Circle({
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 1,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: this.map,
      center: latLng,
      radius: parseInt(event.magnitude) * 10000
    });

    marker.addListener('click', () => {
      infoWindow.open(this.map, marker);
    });

    this.state.events[event.event_id] = {
      circle: circle,
      infoWindow: infoWindow,
      marker: marker
    };
  }
  updateEvent(event) {
    var marker = this.state.events[event.event_id].marker,
        circle = this.state.events[event.event_id].circle,
        infoWindow = this.state.events[event.event_id].infoWindow,
        latLng = {
          lat: parseFloat(event.latitude),
          lng: parseFloat(event.longitude)
        };

    marker.setPosition(latLng);
    marker.setAnimation(google.maps.Animation.BOUNCE);
    circle.setCenter(latLng);
    infoWindow.setContent(this.infoWindowContent(event))

    setTimeout(() => {
      marker.setAnimation(null);
    }, 1400)
  }
  infoWindowContent(event) {
    return '<div class="info-window-content">'+
      '<h6>Event information</h6>'+
      '<ul>'+
        '<li><strong>Where:</strong> ' + event.place + '</li>'+
        '<li><strong>When:</strong> ' + event.time_local + '</li>'+
        '<li><strong>Magnitude:</strong> ' + event.magnitude + ' (' + event.magnitude_type + ')</li>'+
      '</ul>'+
    '</div>';
  }
}

class EventsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = { events: [] };
  }
  componentWillReceiveProps(nextProps) {
    if (nextProps.updated_events) {
      this.updateEvents(nextProps.updated_events);
    }

    if (nextProps.new_events) {
      this.addEvents(nextProps.new_events);
    }
  }
  render() {
    return (
      <div className="container">
        <LatestEvents events={this.props.events} />
      </div>
    )
  }
  addEvents(events) {
    events.forEach(event => {
      this.addEvent(event);
    });
  }
  updateEvents(events) {
    events.forEach(event => {
      this.updateEvent(event);
    });
  }
  addEvent(event) {
    this.setState((previousState, currentProps) => {
      return { events: previousState.events.push(event) };
    });
  }
  updateEvent(event) {
    let eventIndex = this.state.events.findIndex((element, index, array) => {
      element.event_id == updated_event.event_id;
    });

    this.state.events[eventIndex] = event;
  }
}

class LatestEvents extends React.Component {
  render() {
    let rows = this.props.events.map((event) => {
      return (
        <EventRow key={event.event_id}
          place={event.place}
          time={event.time_local}
          magnitude={event.magnitude}
          magnitude_type={event.magnitude_type} />
      )
    })
    return (
      <div className="column">
        <h5>Latest events</h5>

        <table>
          <thead>
            <tr>
              <th>Where</th>
              <th>When</th>
              <th>Magnitude</th>
            </tr>
          </thead>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    )
  }
}

class EventRow extends React.Component {
  render() {
    return (
      <tr>
        <td>{this.props.place}</td>
        <td>{this.props.time}</td>
        <td>{this.props.magnitude} ({this.props.magnitude_type})</td>
      </tr>
    )
  }
}

ReactDOM.render(
  <EventsIndex />,
  document.getElementById('events-index')
)
