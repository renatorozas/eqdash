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

    this.mc = new MarkerClusterer(this.map, this.markers)
  }
  openInfoWindow(markerId) {
    let infoWindow = this.getInfoWindow(markerId),
        marker = this.getMarker(markerId)

    if (!infoWindow || !marker) return

    infoWindow.open(this.map, marker)
  }
  zoomToMarker(markerId) {
    let marker = this.getMarker(markerId)

    if (!marker) return

    this.map.setZoom(10)
    this.map.panTo(marker.position)
  }
  getMarkers() {
    return Object.keys(this.refs).map(key => {
      return this.refs[key].marker
    })
  }
  getMarker(id) {
    let ref = this.refs[id] || {}
      , marker = ref.marker

    return marker
  }
  getInfoWindow(markerId) {
    let ref = this.refs[markerId] || {}
      , infoWindow = ref.infoWindow

    return infoWindow
  }
  addMarker(id, options) {
    let marker = new google.maps.Marker(
      Object.assign({ map: this.map }, options)
    )

    this.refs[id] = { marker: marker }
    this.mc.addMarker(marker)

    return marker
  }
  addInfoWindow(markerId, options) {
    let marker = this.getMarker(markerId)

    if (!marker) return

    let infoWindow = new google.maps.InfoWindow(options)

    marker.addListener('click', () => {
      infoWindow.open(this.map, marker)
    })

    this.refs[markerId].infoWindow = infoWindow
  }
  updateMarker(marker, options) {
    if (options.position) {
      marker.setPosition(options.position)
    }

    if (options.title) {
      marker.setTitle(options.title)
    }

    marker
  }
  updateInfoWindow(infoWindow , options) {
    if (options.content) {
      infoWindow.setContent(options.content)
    }

    infoWindow
  }
  upsertMarker(id, options) {
    var marker = this.getMarker(id)

    if (marker) {
      this.updateMarker(marker, options)
    } else {
      this.addMarker(id, options)
    }

    marker
  }
  upsertInfoWindow(markerId, options) {
    var infoWindow = this.getInfoWindow(markerId)

    if (infoWindow) {
      this.updateInfoWindow(infoWindow, options)
    } else {
      this.addInfoWindow(markerId, options)
    }

    infoWindow
  }
}

export default GoogleMap
