# Parsing JSON using the `Bundle` class

## Objectives

* Write a unit test to test a JSON payload. 
* Parse a local `.json` file using the `Bundle` class. 
* Write a unit test to test reading from the Bundle class and creating Swift model(s). 

## 1. Using a JSON payload in Swift 

1. Navigate to the `.json` file you're interested in using from the [JSON-Examples](https://github.com/alexpaul/JSON-Examples) repo.
2. Copy the `JSON` contents. 
3. Back in your Xcode project create a new file, select `Empty` file in the Xcode new file template.
4. Create a file with a similar name e.g `presidents.json`
5. Save this file in your App navigation folder. 
6. Use the `Bundle` class to read the `.json` file and parse to your Swift object. 

> Make sure the `JSON` contents you copied starts on line 1 in your new file. It won't be valid `JSON` if there are new lines or any comments other than the  `JSON` starting at the open bracket to the the last closed bracket. 

## 2. Create the Swift Model that represents the JSON payload 

```swift 
struct President: Decodable {
  let number: Int
  let name: String
  let birthYear: Int
  let deathYear: Int
  let tookOffice: String
  let leftOffice: String
  let party: String
  
  private enum CodingKeys: String, CodingKey {
    case number
    case name = "president"
    case birthYear = "birth_year"
    case deathYear = "death_year"
    case tookOffice = "took_office"
    case leftOffice = "left_office"
    case party
  }
}
```

## 3. Unit Test the JSON payload along with your Swift model 

```swift 
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
    let firstPresident = presidents[0]
    // assert
    XCTAssertEqual(firstPresident.name, expectedFirstPresident)
  } catch {
    XCTFail("decoding error: \(error)")
  }
}
```

## 4. Use the `Bundle` class to read the `.json` file and decode to Swift objects

```swift 
enum BundleError: Error {
  case invalidResource(String)
  case noContentsAtPath(String)
  case decodingError(Error)
}

extension Bundle {
  func parseJSONFile(with name: String) throws -> [President] {
    guard let path = Bundle.main.path(forResource: name, ofType: ".json") else {
      throw BundleError.invalidResource(name)
    }
    guard let data = FileManager.default.contents(atPath: path) else {
      throw BundleError.noContentsAtPath(path)
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
```

#### Generic `parseJSONFile(with name:)` method 

<details> 
  <summary>Bundle+ParseJSON.swift</summary> 
  
  ```swift 
  extension Bundle {
  func parseJSONFile<T: Decodable>(with name: String) throws -> T {
    guard let path = Bundle.main.path(forResource: name, ofType: ".json") else {
      throw BundleError.invalidResource(name)
    }
    guard let data = FileManager.default.contents(atPath: path) else {
      throw BundleError.noContentsAtPath(path)
    }
    var presidents: T
    do {
      presidents = try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw BundleError.decodingError(error)
    }
    return presidents
  }
}
  ```
  
</details>

## 5. Unit test the `Bundle` extension for decoding the `.json` file 

```swift 
func testParseJSONFromBundle() {
  // arrange
  let bundle = Bundle.main
  let filename = "presidents"
  let firstBlackPresident = "Barack Obama"

  // act
  do {
    let presidents = try bundle.parseJSONFile(with: filename)
    // assert
    XCTAssertEqual(firstBlackPresident, presidents[43].name)
  } catch {
    XCTFail("bundle read error: \(error)")
  }
}
```

## 6. Populate the results in a Table View 

```swift 
class FeedViewController: UIViewController {
  enum Section {
    case main
  }
  
  typealias DataSource = UITableViewDiffableDataSource<Section, President>
  
  @IBOutlet weak var tableView: UITableView!
  private var dataSource: DataSource!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    configureDataSource()
    fetchPresidents()
  }
  
  private func configureDataSource() {
    dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, president) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = president.name
      cell.detailTextLabel?.text = president.number.description
      return cell
    })
    dataSource.defaultRowAnimation = .fade
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, President>()
    snapshot.appendSections([.main])
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  private func fetchPresidents() {
    var presidents: [President]
    do {
      presidents = try Bundle.main.parseJSONFile(with: "presidents")
    } catch {
      fatalError("error: \(error)")
    }
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(presidents, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }

}
```

## 7. Table View 

![presidents](https://github.com/alexpaul/JSON-Examples/blob/master/Assets/presidents.png)
