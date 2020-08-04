# Using Combine for making Network Requests

## APIClient 

Here in Combine we have access to `dataTaskPublisher` and `decode()` wrappers which makes our networking code much more functional that using closures. 

We use `.map(\.data)` keypath to access the data property from the data task. 

Since our publisher returns an array of stattions we use map again to get the stations array. 

We handle dispatching back to the main thread in the client so the view controller does not have to do this work. 

`.eraseToAnyPublisher` hided the implementation detail from the client code. 

```swift 
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
```

## View Controller subscribing to the `fetchData()` publisher

We subscribe to the publisher and use `.sink` to receive the emitted values from the publisher. 

```swift 
private func fetchData() {
  do {
    let publisher = try apiClient.fetchData()
    publisher
      .sink(receiveCompletion: { (completion) in
        print(completion)
      }, receiveValue: { [weak self]  (stations) in
        self?.updateSnapshot(with: stations)
      })
    .store(in: &subscriptions
    )
  } catch {
    print(error)
  }
}
```
