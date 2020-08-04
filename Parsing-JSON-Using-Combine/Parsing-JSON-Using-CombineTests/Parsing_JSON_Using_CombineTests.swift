//
//  Parsing_JSON_Using_CombineTests.swift
//  Parsing-JSON-Using-CombineTests
//
//  Created by Alex Paul on 8/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
@testable import Parsing_JSON_Using_Combine

class Parsing_JSON_Using_URLSessionTests: XCTestCase {

  func testModel() {
    // arrange
    let jsonData = """
    {
      "data": {
        "stations": [{
            "rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=72",
            "station_type": "classic",
            "station_id": "72",
            "eightd_has_key_dispenser": false,
            "lat": 40.76727216,
            "eightd_station_services": [],
            "legacy_id": "72",
            "region_id": "71",
            "name": "W 52 St & 11 Ave",
            "has_kiosk": true,
            "short_name": "6926.01",
            "electric_bike_surcharge_waiver": false,
            "lon": -73.99392888,
            "capacity": 55,
            "external_id": "66db237e-0aca-11e7-82f6-3863bb44ef7c",
            "rental_methods": [
              "CREDITCARD",
              "KEY"
            ]
          },
          {
            "rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=79",
            "station_type": "classic",
            "station_id": "79",
            "eightd_has_key_dispenser": false,
            "lat": 40.71911552,
            "eightd_station_services": [],
            "legacy_id": "79",
            "region_id": "71",
            "name": "Franklin St & W Broadway",
            "has_kiosk": true,
            "short_name": "5430.08",
            "electric_bike_surcharge_waiver": false,
            "lon": -74.00666661,
            "capacity": 33,
            "external_id": "66db269c-0aca-11e7-82f6-3863bb44ef7c",
            "rental_methods": [
              "CREDITCARD",
              "KEY"
            ]
          }
        ]
      }
    }
    """.data(using: .utf8)!
    
    let expectedCapacity = 55 // bikes
    
    // act
    do {
      let results = try JSONDecoder().decode(ResultsWrapper.self, from: jsonData)
      let stations = results.data.stations // [Station]
      let firstStation = stations[0]
      // assert
      XCTAssertEqual(expectedCapacity, firstStation.capacity) // 55 == 55
    } catch {
      XCTFail("decoding error: \(error)")
    }
  }

}
