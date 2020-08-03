//
//  Parsing_JSON_Using_BundleTests.swift
//  Parsing-JSON-Using-BundleTests
//
//  Created by Alex Paul on 8/3/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
@testable import Parsing_JSON_Using_Bundle

class Parsing_JSON_Using_BundleTests: XCTestCase {

  // all unit test has to be prefixed with the word "test"
  
  // 3 steps to unit test
  
  func testModel() {
    // arrange
    let jsonData = """
    [{
        "number": 1,
        "president": "George Washington",
        "birth_year": 1732,
        "death_year": 1799,
        "took_office": "1789-04-30",
        "left_office": "1797-03-04",
        "party": "No Party"
      },
      {
        "number": 2,
        "president": "John Adams",
        "birth_year": 1735,
        "death_year": 1826,
        "took_office": "1797-03-04",
        "left_office": "1801-03-04",
        "party": "Federalist"
      }
    ]
    """.data(using: .utf8)!
    
    let expectedFirstPresident = "George Washington"
    
    // act
    do {
      let presidents = try JSONDecoder().decode([President].self, from: jsonData)
      // assert
      XCTAssertEqual(expectedFirstPresident, presidents[0].name)
    } catch {
      XCTFail("decoding error: \(error)")
    }
  }
  
  func testParseJSONFromBundle() {
    // arrange
    let filename = "presidents"
    let firstBlackPresident = "Barack Obama"
    
    // act
    do {
      let presidents = try Bundle.main.parseJSON(with: filename)
      // assert
      XCTAssertEqual(firstBlackPresident, presidents[43].name)
    } catch {
      XCTFail("decoding error: \(error)")
    }
  }

}
