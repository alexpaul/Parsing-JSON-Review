# Using Combine for making asynchronous network requests

## APIClient 

Here in Combine we have access to `dataTaskPublisher` and `decode()` wrappers which makes our networking code much more functional than using closures. 

We use `.map(\.data)` keypath to access the data property from the data task arguments, namely response, data and error. 

Since our publisher returns an array of stations we use map again `.map { $0.data.stations }` to get the stations array. 

We handle dispatching back to the main thread in the `APIClient` so the view controller does not have to do this work. 

`.eraseToAnyPublisher` hides the implementation detail from the client code. 

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

We store our subscribers in the case of the need to cancel a subscription `.store(in: &subscriptions`. 

```swift 
private var subscriptions: Set<AnyCancellable> = []

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

## More resources on Combine 

1. [Introducing Combine - WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/722/)
2. [Combine in Practice - WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/721/)
3. [Using Combine](https://heckj.github.io/swiftui-notes/#aboutthisbook)
4. [Apple docs - Combine](https://developer.apple.com/documentation/combine)
5. [Apple docs - Processing URL Session Data Task Results with Combine](https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine)
