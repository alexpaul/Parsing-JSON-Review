//
//  Station.swift
//  Parsing-JSON-Using-Combine
//
//  Created by Alex Paul on 8/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

// review Float vs Double, a Double holds more floating point values than a Float

// Top Level
struct ResultsWrapper: Decodable {
  let data: StationsWrapper
}

struct StationsWrapper: Decodable {
  let stations: [Station]
}

struct Station: Decodable, Hashable {
  let name: String
  let stationType: String // station_type => stationType
  let latitude: Double
  let longitude: Double
  let capacity: Int
  
  private enum CodingKeys: String, CodingKey {
    case name
    case stationType = "station_type"
    case latitude = "lat"
    case longitude = "lon"
    case capacity
  }
}
