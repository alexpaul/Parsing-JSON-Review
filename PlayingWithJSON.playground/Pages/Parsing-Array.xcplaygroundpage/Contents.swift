import Foundation

//===================================================
// JSON data
//===================================================


let json = """
[
    {
        "title": "New York",
        "location_type": "City",
        "woeid": 2459115,
        "latt_long": "40.71455,-74.007118"
    }
]
""".data(using: .utf8)!

//===================================================
// Create model(s)
//===================================================


struct City: Decodable {
  let title: String
  let locationType: String
  
  // reminder - once property names are changed
  // using CodingKeys, they must match identically to
  // the case type
  //let location_type: String
  
  let coordinate: String
  let woeid: Int
  
  //let latt_long: String
  
  private enum CodingKeys: String, CodingKey {
    case title
    case locationType = "location_type"
    case woeid
    case coordinate = "latt_long"
  }
}

//===================================================
// decode JSON to Swift objects
//===================================================

do {
  let weatherArray = try JSONDecoder().decode([City].self, from: json)
  dump(weatherArray)
} catch {
  print("decoding error: \(error)")
}
