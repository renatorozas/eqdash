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
import React from "react"
import ReactDOM from "react-dom"

class EventBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {events: []};
  }
  componentWillMount() {
    // Now that you are connected, you can join channels with a topic:
    let channel = socket.channel("events:index", {})
    let self = this

    channel.on("new_events", payload => {
      console.log(payload);
    });

    channel.join()
      .receive("ok", resp => {
        console.log("Subscribed successfully")
        self.setState(resp)
      })
      .receive("error", resp => {
        console.log("Unable to Subscribe", resp)
      })
  }
  render() {
    return (
      <div className="eventBox">
        <h5>Latest events</h5>
        <EventList events={this.state.events} />
      </div>
    )
  }
}

class EventList extends React.Component {
  render() {
    let rows = this.props.events.map((event) => {
      return (
        <Event key={event.event_id} place={event.place} time={event.time_local} magnitude={event.magnitude} />
      )
    })
    return (
      <table className="eventList">
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
    )
  }
}

class Event extends React.Component {
  render() {
    return (
      <tr>
        <td>{this.props.place}</td>
        <td>{this.props.time}</td>
        <td>{this.props.magnitude}</td>
      </tr>
    )
  }
}

ReactDOM.render(
  <EventBox />,
  document.getElementById('event-box')
)
