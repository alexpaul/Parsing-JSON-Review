//
//  APIClient.swift
//  Parsing-JSON-Using-Combine
//
//  Created by Alex Paul on 8/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import Combine

enum AppError: Error {
  case badURL(String)
  case networkError(Error)
  case decodingError(Error)
}

class APIClient {
  func fetchData() throws -> AnyPublisher<[Station], Error> {
    let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
    guard let url = URL(string: endpoint) else {
      throw AppError.badURL(endpoint)
    }
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: ResultsWrapper.self, decoder: JSONDecoder())
      .map { $0.data.stations }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
