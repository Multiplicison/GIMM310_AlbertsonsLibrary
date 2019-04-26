import CoreLocation

enum Constants {
  // Radius of circle around library to be in range
  static let geofencingRadius: Double = 300.0



 //Lat and longitude of center of library
  static let LibraryLocation = Location(name: "Library", location: CLLocationCoordinate2D(latitude: 43.604218, longitude: -116.203367))

  static let libIdentifier = "Albertsons Library"

  struct Location {
    let name: String
    let location: CLLocationCoordinate2D
  }
}

