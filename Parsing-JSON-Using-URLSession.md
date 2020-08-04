# Parsing JSON using `URLSession`

Parsing JSON using `URLSession` and the `Decodable` protocol. 

## Objectives

* Write unit test to validate sample JSON payload from a Web API along with your Swift model. 
* Use `URLSession` to write an API client to decode JSON to Swift objects. 

## Open APIs 

1. Apple Search API (podcasts) - `https://itunes.apple.com/search?media=podcast&limit=200&term=swift`
2. Citi Bike (Station Information) - `https://gbfs.citibikenyc.com/gbfs/en/station_information.json`
3. Random User Generator - `https://randomuser.me/api/?results=50`
4. Open Trivia - `https://opentdb.com/api.php?amount=29&category=18&difficulty=easy&type=multiple`
5. COVID19 (summary of new and total cases per country) - `https://api.covid19api.com/summary`

## 1. Write Unit test to validate JSON 

Web API - `https://gbfs.citibikenyc.com/gbfs/en/station_information.json`

#### 1. Open up Postman and run a `GET` request agaist the endpoint above. 

Get a snippet of the JSON to use for a Unit test. 

```json 
{
	"data": {
		"stations": [{
				"electric_bike_surcharge_waiver": false,
				"rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=72",
				"rental_methods": [
					"CREDITCARD",
					"KEY"
				],
				"short_name": "6926.01",
				"external_id": "66db237e-0aca-11e7-82f6-3863bb44ef7c",
				"eightd_station_services": [],
				"name": "W 52 St & 11 Ave",
				"capacity": 55,
				"legacy_id": "72",
				"station_id": "72",
				"station_type": "classic",
				"lon": -73.99392888,
				"lat": 40.76727216,
				"has_kiosk": true,
				"region_id": "71",
				"eightd_has_key_dispenser": false
			},
			{
				"electric_bike_surcharge_waiver": false,
				"rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=79",
				"rental_methods": [
					"CREDITCARD",
					"KEY"
				],
				"short_name": "5430.08",
				"external_id": "66db269c-0aca-11e7-82f6-3863bb44ef7c",
				"eightd_station_services": [],
				"name": "Franklin St & W Broadway",
				"capacity": 33,
				"legacy_id": "79",
				"station_id": "79",
				"station_type": "classic",
				"lon": -74.00666661,
				"lat": 40.71911552,
				"has_kiosk": true,
				"region_id": "71",
				"eightd_has_key_dispenser": false
			}
		]
	}
}
```

#### 2. Create Swift model 

```swift 
struct ResultsWrapper: Decodable {
  let data: Container
}

struct Container: Decodable {
  let stations: [Station]
}

struct Station: Decodable, Hashable {
  let name: String
  let station_id: String
  let capacity: Int
  let lat: Double
  let lon: Double
}
```

#### 3. Unit test the model against the JSON payload

```swift 
func testModel() {
  // arrange
  let jsonData = """
  {
    "data": {
      "stations": [{
          "electric_bike_surcharge_waiver": false,
          "rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=72",
          "rental_methods": [
            "CREDITCARD",
            "KEY"
          ],
          "short_name": "6926.01",
          "external_id": "66db237e-0aca-11e7-82f6-3863bb44ef7c",
          "eightd_station_services": [],
          "name": "W 52 St & 11 Ave",
          "capacity": 55,
          "legacy_id": "72",
          "station_id": "72",
          "station_type": "classic",
          "lon": -73.99392888,
          "lat": 40.76727216,
          "has_kiosk": true,
          "region_id": "71",
          "eightd_has_key_dispenser": false
        },
        {
          "electric_bike_surcharge_waiver": false,
          "rental_url": "http://app.citibikenyc.com/S6Lr/IBV092JufD?station_id=79",
          "rental_methods": [
            "CREDITCARD",
            "KEY"
          ],
          "short_name": "5430.08",
          "external_id": "66db269c-0aca-11e7-82f6-3863bb44ef7c",
          "eightd_station_services": [],
          "name": "Franklin St & W Broadway",
          "capacity": 33,
          "legacy_id": "79",
          "station_id": "79",
          "station_type": "classic",
          "lon": -74.00666661,
          "lat": 40.71911552,
          "has_kiosk": true,
          "region_id": "71",
          "eightd_has_key_dispenser": false
        }
      ]
    }
  }
  """.data(using: .utf8)!
  
  let expectedCapcity = 55
  
  // act
  do {
    let results = try JSONDecoder().decode(ResultsWrapper.self, from: jsonData)
    let station = results.data.stations[0]
    // assert
    XCTAssertEqual(station.capacity, expectedCapcity)
  } catch {
    XCTFail("decoding error: \(error)")
  }
}
```

## 2. Use `URLSession` to write an API client to parse JSON 

```swift 
import Foundation

enum AppError: Error {
  case badURL(String)
  case decodingError(Error)
  case networkError(Error)
}

class APIClient {
  func fetchData(completion: @escaping (Result<[Station], AppError>) -> ()) {
    let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
    guard let url = URL(string: endpoint) else {
      completion(.failure(.badURL(endpoint)))
      return
    }
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(.networkError(error)))
        return
      } else if let data = data {
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
```

## 3. Populate a Table View with the fetched data  

```swift 
class FeedViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  typealias DataSource = UITableViewDiffableDataSource<Int, Station>
  
  private var dataSource: DataSource!
  private let apiClient = APIClient()
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    configureDataSource()
    fetchData()
  }
  
  private func fetchData() {
    apiClient.fetchData { [weak self] (result) in
      switch result {
      case .failure(let appError):
        dump(appError)
      case .success(let stations):
        DispatchQueue.main.async {
          self?.updateSnapshot(with: stations)
        }
      }
    }
  }
  
  private func updateSnapshot(with countries: [Station]) {
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(countries, toSection: 0)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  private func configureDataSource() {
    dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, station) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = station.name
      cell.detailTextLabel?.text = station.capacity.description
      return cell
    })
    
    var snapshot = NSDiffableDataSourceSnapshot<Int, Station>()
    snapshot.appendSections([0])
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
```

![citi bike stations](https://github.com/alexpaul/Parsing-JSON-Review/blob/master/Assets/citi-bike-stations.png)


