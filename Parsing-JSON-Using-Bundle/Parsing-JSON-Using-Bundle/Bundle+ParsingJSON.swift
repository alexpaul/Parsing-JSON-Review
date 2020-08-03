//
//  Bundle+ParsingJSON.swift
//  Parsing-JSON-Using-Bundle
//
//  Created by Alex Paul on 8/3/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation


enum BundleError: Error {
  case invalidResource(String)
  case noContents(String)
  case decodingError(Error)
}

extension Bundle {
  
  // 1. Get the (path) of the file to be read using the Bundle class => String?
  // 2. Using the path read it's data contents => Data?
  
  // Bundle.main is a singleton
  // FileManager.default is a singleton
  
  // parseJSON will be a throwing function
  // to use throwing function you have to use try? or do {} catch{} or try!
  func parseJSON(with name: String, ext: String = ".json") throws -> [President] {
    
    guard let path = Bundle.main.path(forResource: name, ofType: ext) else {
      throw BundleError.invalidResource(name)
    }
    
    guard let data = FileManager.default.contents(atPath: path) else {
      throw BundleError.noContents(path)
    }
    
    var presidents: [President]
    
    do {
      presidents = try JSONDecoder().decode([President].self, from: data)
    } catch {
      throw BundleError.decodingError(error)
    }
    
    return presidents
  }
  
}
