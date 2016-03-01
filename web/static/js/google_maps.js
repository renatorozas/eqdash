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

    return marker
  }
  addInfoWindow(markerId, options) {
    let marker = this.refs[markerId].marker
      , infoWindow = new google.maps.InfoWindow(options)

    marker.addListener('click', () => {
      infoWindow.open(this.map, marker)
    })

    this.refs[markerId].infoWindow = infoWindow
  }
  updateMarker(id, options) {
    var ref = this.refs[id]

    if (!ref) return

    if (options.position) {
      ref.marker.setPosition(options.position)
    }

    if (options.title) {
      ref.marker.setTitle(options.title)
    }
  }
  updateInfoWindow(id, options) {
    var ref = this.refs[id]

    if (!ref) return

    if (options.content) {
      ref.infoWindow.setContent(options.content)
    }
  }
}

export default GoogleMap
