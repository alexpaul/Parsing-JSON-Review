//
//  APIClient.swift
//  Parsing-JSON-Using-URLSession
//
//  Created by Alex Paul on 8/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

// TODO: convert to a Generic APIClient<Station>()
// conform APIClient to Decodable

enum AppError: Error {
  case badURL(String)
  case networkError(Error)
  case decodingError(Error)
}

class APIClient {
  // the fetchData() method does an asynchronous network call
  // this means the method returns (BEFORE) the request is complete
  
  // when dealing with asynchronous calls we use a closure,
  // other mechanisms you can use include: delegation, NotificationCenter,
  // newer to iOS developers as of iOS 13 is (Combine)
  
  // closures captures values, it's a reference type
  
  func fetchData(completion: @escaping (Result<[Station], AppError>) -> () ) {
    let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
    
    //"prospect park".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    
    // 1.
    // we need a URL to create our Network Request
    guard let url = URL(string: endpoint) else {
      completion(.failure(.badURL(endpoint)))
      return
    }
    
    // 2. create a GET request, other request examples POST, DELETE, PATCH, PUT
    let request = URLRequest(url: url)
    
    //request.httpMethod = "POST"
    //request.httpBody = data
    //request.addValue("BearerToken", forHTTPHeaderField: "lafldalfdj0oda")
    //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 3. use URLSession to make the Network Request
    // URLSession.shared is a singleton
    // this is sufficient to use for making most request
    // using URLSession without the shared instance gives you access
    // to adding necessary configurations to your task
    let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(.failure(.networkError(error)))
        return
      }
      
      if let data = data {
        // 4. decode the JSON to our Swift model
        do {
          let results = try JSONDecoder().decode(ResultsWrapper.self, from: data)
          completion(.success(results.data.stations))
        } catch {
          completion(.failure(.decodingError(error)))
        }
      }
    }
    dataTask.resume()
  }
}
