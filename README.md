# Parsing JSON Review

Parsing JSON review. In this review we will be using _Playgrounds_, using _Unit Tests_, reading from the _App Bundle_ and displaying the _JSON_ data in a table view.

## Objective

* What is JSON
* Parsing various JSON structures, namely dictionary and array data structures 
* Using Playgrounds to parse JSON 
* Writing a Unit Test to validate your Swift model
* Parsing local JSON using the `Bundle` class
* Parsing JSON using `URLSession` from a Web API

[JSON](https://www.json.org/json-en.html) - _JavaScript Object Notation_. To review JSON is structured using one of two data structures, it can be structued using an array or a dictionary. 

## 1. JSON examples 

#### Example 1 

```json 
{
 "results": [
   {
     "firstName": "John",
     "lastName": "Appleseed"
   },
  {
    "firstName": "Alex",
    "lastName": "Paul"
  }
 ]
}
```

#### What data struture is used to create this JSON structure above? 

<details> 
 <summary>Solution</summary> 
 The root level is a dictionary. 
 
 ```swift 
 do {
   let dictionary = try JSONDecoder().decode(ContactsWrapper.self, from: data)
 } catch {
   print(error)
 }
 ```
</details> 

#### Example 2 

```json 
[
    {
        "title": "New York",
        "location_type": "City",
        "woeid": 2459115,
        "latt_long": "40.71455,-74.007118"
    }
]
```

#### What data struture is used to create this JSON structure above? 

<details> 
 <summary>Solution</summary> 
 The root level is an array. 
 
  ```swift 
 do {
   let weatherArray = try JSONDecoder().decode([Weather].self, from: data)
 } catch {
   print(error)
 }
 ```
</details> 

#### Example 3 

```json 
{
  "Afpak": {
    "id": 1,
    "race": "hybrid",
    "flavors": [
      "Earthy",
      "Chemical",
      "Pine"
    ],
    "effects": {
      "positive": [
        "Relaxed",
        "Hungry",
        "Happy",
        "Sleepy"
      ],
      "negative": [
        "Dizzy"
      ],
      "medical": [
        "Depression",
        "Insomnia",
        "Pain",
        "Stress",
        "Lack of Appetite"
      ]
    }
  },
  "African": {
    "id": 2,
    "race": "sativa",
    "flavors": [
      "Spicy/Herbal",
      "Pungent",
      "Earthy"
    ],
    "effects": {
      "positive": [
        "Euphoric",
        "Happy",
        "Creative",
        "Energetic",
        "Talkative"
      ],
      "negative": [
        "Dry Mouth"
      ],
      "medical": [
        "Depression",
        "Pain",
        "Stress",
        "Lack of Appetite",
        "Nausea",
        "Headache"
      ]
    }
  }
}
```

#### What data struture is used to create this JSON structure above? 

<details> 
 <summary>Solution</summary> 
 The root level is a dictionary. However here we are not only interested in a single key:value pair. We need to parse all the key, values. So in this case we will represent the top level using dictionary syntax, where the key is a String and the value is the Codable object. e.g `[String: Strain]`.
 
  ```swift 
 do {
   let dictionary = try JSONDecoder().decode([String: Strain].self, from: data)
   var strains: [Strain]
   for (_, value) in dictionary {
     let strain = Strain(id: value.id, race: value.race) // along with any other properties you need
     strains.append(strain)
   }
   // now here we have an array of strains 
 } catch {
   print(error)
 }
 ```
</details> 

#### Example 4 

```json
{
  "results": [{
      "gender": "male",
      "name": {
        "title": "Mr",
        "first": "Asher",
        "last": "King"
      },
      "location": {
        "street": {
          "number": 6848,
          "name": "Madras Street"
        },
        "city": "Whanganui",
        "state": "Manawatu-Wanganui",
        "country": "New Zealand",
        "postcode": 83251,
        "coordinates": {
          "latitude": "64.3366",
          "longitude": "-140.5100"
        },
        "timezone": {
          "offset": "0:00",
          "description": "Western Europe Time, London, Lisbon, Casablanca"
        }
      },
      "email": "asher.king@example.com",
      "login": {
        "uuid": "157a7e5d-6023-40bc-8b72-d391c5a20e73",
        "username": "lazycat871",
        "password": "punkin",
        "salt": "xchlaTXG",
        "md5": "1de85cd9e9fb19e4932fa2d94397f9f7",
        "sha1": "695dbe4886625b61d766320f4c759d920bd03c06",
        "sha256": "7df1eb54d38a127e7f181590f802c8ee5a6c887b141b5e90ee981eee719b9f71"
      },
      "dob": {
        "date": "1955-07-04T19:24:43.057Z",
        "age": 65
      },
      "registered": {
        "date": "2012-04-01T10:07:09.601Z",
        "age": 8
      },
      "phone": "(736)-108-4205",
      "cell": "(736)-836-4316",
      "id": {
        "name": "",
        "value": null
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/men/6.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/6.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/6.jpg"
      },
      "nat": "NZ"
    },
    {
      "gender": "female",
      "name": {
        "title": "Ms",
        "first": "Madison",
        "last": "Williams"
      },
      "location": {
        "street": {
          "number": 64,
          "name": "Argyle St"
        },
        "city": "Kingston",
        "state": "Ontario",
        "country": "Canada",
        "postcode": "L7J 7K7",
        "coordinates": {
          "latitude": "-80.5612",
          "longitude": "2.7939"
        },
        "timezone": {
          "offset": "+4:00",
          "description": "Abu Dhabi, Muscat, Baku, Tbilisi"
        }
      },
      "email": "madison.williams@example.com",
      "login": {
        "uuid": "b5ad5a75-2a2c-4bfb-9028-a6ef95f85068",
        "username": "lazyostrich722",
        "password": "genesis1",
        "salt": "58Mw0Gvb",
        "md5": "af2a89591d1be11120ac0de395818eb7",
        "sha1": "63c2a6c7ddf7051a56c88ca767bc1579d88472fe",
        "sha256": "509e975c1f0ef8720b6990b6922e8c30a7f589e728b001bcd6092b4a6a55b234"
      },
      "dob": {
        "date": "1977-01-11T04:47:50.049Z",
        "age": 43
      },
      "registered": {
        "date": "2003-01-06T04:41:11.111Z",
        "age": 17
      },
      "phone": "326-431-8326",
      "cell": "042-933-3343",
      "id": {
        "name": "",
        "value": null
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/women/9.jpg",
        "medium": "https://randomuser.me/api/portraits/med/women/9.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/women/9.jpg"
      },
      "nat": "CA"
    }
  ]
}
```

#### What data struture is used to create this JSON structure above? 

<details> 
 <summary>Solution</summary> 
 The root level is a dictionary. 
 
 Since `postcode` is heterogeneous (varied data type) we have to handle it by using an `enum` called PostCode that will override the `init(with decoder:)` method. 
 
 ```swift 
  struct Person: Decodable {
   // other properties
   /*
    .
    .
    */
   let location: Location
  }

  struct Location: Decodable {
   let postcode: PostCode
  }

  enum DecodingError: Error {
   case missingValue
  }

  enum PostCode: Decodable {
   case int(Int)
   case string(String)

   init(from decoder: Decoder) throws {
     if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
       self = .int(intValue)
       return
     }
     if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
       self = .string(stringValue)
     }
     throw DecodingError.missingValue
   }
  }
 ```
</details> 

## 2. Parsing JSON using Swift Playgrounds 

```swift 
let json = """
{
 "results": [
   {
      "dataStructure": "Array"
    },
    {
      "dataStructure": "Dictionary"
    },
    {
      "dataStructure": "Stack"
    }
 ]
}
""".data(using: .utf8)!

struct DSAWrapper: Decodable {
  let results: [DSA]
}

struct DSA: Decodable {
  let dataStructure: String
}


let dictionary = try JSONDecoder().decode(DSAWrapper.self, from: json)

dump(dictionary.results)

/*
 ▿ 3 elements
 ▿ __lldb_expr_214.DSA
   - dataStructure: "Array"
 ▿ __lldb_expr_214.DSA
   - dataStructure: "Dictionary"
 ▿ __lldb_expr_214.DSA
   - dataStructure: "Stack"
*/
```

## 3. Parsing JSON from the App `Bundle`

```swift 
extension Bundle {
  enum BundleError: Error {
    case noResource(String)
    case noContents(String)
    case decodingError(Error)
  }
  
  func parseJSONData<T: Decodable>(_ name: String, ext: String = "json") throws -> T {
    guard let path = Bundle.main.path(forResource: name, ofType: ext) else {
      throw BundleError.noResource(name)
    }
    guard let data = FileManager.default.contents(atPath: path) else {
      throw BundleError.noContents(path)
    }
    var elements: T
    do {
      elements = try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw BundleError.decodingError(error)
    }
    return elements
  }
}
```

## 4. Parsing JSON using a unit test 

```swift 
func testCreatePodcastModel() {
  let json = """
  {
    "resultCount": 158,
    "results": [{
      "wrapperType": "track",
      "kind": "podcast",
      "artistId": 1019380766,
      "collectionId": 1209817203,
      "trackId": 1209817203,
      "artistName": "Spec, JP Simard, Jesse Squires",
      "collectionName": "Swift Unwrapped",
      "trackName": "Swift Unwrapped",
      "collectionCensoredName": "Swift Unwrapped",
      "trackCensoredName": "Swift Unwrapped",
      "artistViewUrl": "https://podcasts.apple.com/us/artist/spec/1019380766?uo=4",
      "collectionViewUrl": "https://podcasts.apple.com/us/podcast/swift-unwrapped/id1209817203?uo=4",
      "feedUrl": "https://feeds.simplecast.com/3pGv88mm",
      "trackViewUrl": "https://podcasts.apple.com/us/podcast/swift-unwrapped/id1209817203?uo=4",
      "artworkUrl30": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/4f/33/5c/4f335ccf-a9b8-672b-9c79-635925a70787/mza_3481066685613843705.jpg/30x30bb.jpg",
      "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/4f/33/5c/4f335ccf-a9b8-672b-9c79-635925a70787/mza_3481066685613843705.jpg/60x60bb.jpg",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/4f/33/5c/4f335ccf-a9b8-672b-9c79-635925a70787/mza_3481066685613843705.jpg/100x100bb.jpg",
      "collectionPrice": 0.00,
      "trackPrice": 0.00,
      "trackRentalPrice": 0,
      "collectionHdPrice": 0,
      "trackHdPrice": 0,
      "trackHdRentalPrice": 0,
      "releaseDate": "2020-06-18T12:00:00Z",
      "collectionExplicitness": "cleaned",
      "trackExplicitness": "cleaned",
      "trackCount": 87,
      "country": "USA",
      "currency": "USD",
      "primaryGenreName": "Technology",
      "contentAdvisoryRating": "Clean",
      "artworkUrl600": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/4f/33/5c/4f335ccf-a9b8-672b-9c79-635925a70787/mza_3481066685613843705.jpg/600x600bb.jpg",
      "genreIds": [
        "1318",
        "26"
      ],
      "genres": [
        "Technology",
        "Podcasts"
      ]
    }]
  }
  """.data(using: .utf8)!
  
  struct ResultsWrapper: Decodable {
    let results: [Podcast]
  }
  
  struct Podcast: Decodable {
    let artistName: String
    let collectionName: String
    let artworkUrl600: String
  }
  
  // arrange
  let expectedCollectionName = "Swift Unwrapped"
  
  // act
  do {
    let dictionary = try JSONDecoder().decode(ResultsWrapper.self, from: json)
    // assert
    XCTAssertEqual(expectedCollectionName, dictionary.results.first?.collectionName, "should be equal to \(expectedCollectionName)")
  } catch {
    XCTFail("decoding error: \(error)")
  }
}
```

## 5. Parsing JSON using `URLSession`

```swift 
enum APIClientError: Error {
  case badURL(String)
  case decodingError(Error)
  case failedReadingFromBundle
  case networkError(Error)
}

class APIClient<T: Decodable> {
  private let endpoint: String
  
  init(with endpoint: String) {
    self.endpoint = endpoint
  }
  
  func fetchObjects(completion: @escaping (Result<T, APIClientError>) -> ()) {
    guard let url = URL(string: endpoint) else {
      completion(.failure(.badURL(endpoint)))
      return
    }
    
    let request = URLRequest(url: url)
    
    let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(.failure(.networkError(error)))
        return
      }
      else if let data = data {
        do {
          let objects = try JSONDecoder().decode(T.self, from: data)
          completion(.success(objects))
        } catch {
          completion(.failure(.decodingError(error)))
        }
      }
    }
    dataTask.resume()
  }
}
```

## Challenge 

Parse the following JSON and populate the results in a table view. Also include the key e.g `-LG_XMr0arhZYnHJrzmh` as part of your Swift model: 

<details> 
 <summary>JSON data</summary> 
 
 ```json 
 {
    "-LG_XMr0arhZYnHJrzmh": {
        "distance": "Half iron distance triathlon",
        "eventType": "Triathlon"
    },
    "-LG_Xcwf28oXMqnqQcK8": {
        "distance": "Full iron distance triathlon",
        "eventType": "Triathlon"
    },
    "-LG_Xl6p1h5lyV2_mUxp": {
        "distance": "Olympic",
        "eventType": "Triathlon"
    },
    "-LG_XmX6uiMlAiXt5QNq": {
        "distance": "Sprint",
        "eventType": "Triathlon"
    },
    "-LG_Y1XvoEjFT0EN4S3N": {
        "distance": "Marathon",
        "eventType": "Running"
    },
    "-LG_Y3za7hwh9wAadqeE": {
        "distance": "Half marathon",
        "eventType": "Running"
    },
    "-LG_YDSzuu7hMgNboUlP": {
        "distance": "10K",
        "eventType": "Running"
    },
    "-LG_YInlc2DeM7o-G4wv": {
        "distance": "5K",
        "eventType": "Running"
    },
    "-LG_YLbTw_7y597IQE6U": {
        "distance": "1 mile",
        "eventType": "Running"
    },
    "-LG_YQefvZTbQkeQ-jGR": {
        "distance": "100K",
        "eventType": "Running"
    },
    "-LG_YSBOIJP1TgWLvkGg": {
        "distance": "100 miles",
        "eventType": "Running"
    },
    "-LG_YVVasMWmb_qumtEE": {
        "distance": "50 miles",
        "eventType": "Running"
    },
    "-LG_Ya2AzCAwteR49IB8": {
        "distance": "50K",
        "eventType": "Running"
    },
    "-LG_YgMBkg_subRo8d4W": {
        "distance": "10K",
        "eventType": "Swimming"
    },
    "-LG_Yhrrf69r_5e2Havn": {
        "distance": "5K",
        "eventType": "Swimming"
    },
    "-LG_Yjq1MBuBh8JBfAYE": {
        "distance": "1 mile",
        "eventType": "Swimming"
    },
    "-LG_Ymp64cKQB1xBFj1r": {
        "distance": "2.4 mile",
        "eventType": "Swimming"
    },
    "-LG_Yoi_Vh0gOC1B_xsy": {
        "distance": "1.2 mile",
        "eventType": "Swimming"
    }
}
 ```
 
</details> 

## Endpoints

1. [Punk API](https://api.punkapi.com/v2/beers?brewed_before=11-2012&abv_gt=6)
1. [Citi Bike Station Information](https://gbfs.citibikenyc.com/gbfs/en/station_information.json)
1. [Podcast Search](https://itunes.apple.com/search?media=podcast&limit=200&term=swift)
1. [RandomUser](https://randomuser.me/api/?results=50)
1. [Strains](http://strainapi.evanbusse.com/SJ56zEa/strains/search/all)


## Resources 

1. [JSONLint](https://jsonlint.com/)
2. [Quicktype - Convert JSON to Swift](https://quicktype.io/)
3. [Structures of JSON](https://www.w3resource.com/JSON/structures.php)
4. [JSON Cheatsheet](https://gist.github.com/alexpaul/3f81787eeffc32e11fdfeef9310cdcf8)
5. [JSON.org](https://www.json.org/json-en.html)
6. [Working with JSON](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON)
