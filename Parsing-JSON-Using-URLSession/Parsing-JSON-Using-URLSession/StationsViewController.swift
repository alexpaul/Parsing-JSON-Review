//
//  ViewController.swift
//  Parsing-JSON-Using-URLSession
//
//  Created by Alex Paul on 8/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import Combine

class StationsViewController: UIViewController {
  
  // TODO: use the "region_id" to create multiple sections
  // create an enum to represent our table view sections
  enum Section {
    case primary
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  private var dataSource: DataSource! // subclass of UITableViewDiff..Source
  
  let apiClient = APIClient()
  
  private var subscriptions: Set<AnyCancellable> = []

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Citi Bike Stations"
    configureDataSource()
    fetchData()
  }
  
  private func fetchData() {
    // Result type has two values
    // 1. .failure() or 2. .success()
    apiClient.fetchData { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print(appError)
        // TODO: present an alert
      case .success(let stations):
        DispatchQueue.main.async { // update UI on the main thread
          self?.updateSnapshot(with: stations)
        }
      }
    }
  }
  
  private func updateSnapshot(with stations: [Station]) {
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(stations, toSection: .primary)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  private func configureDataSource() {
    dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, station) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = station.name
      cell.detailTextLabel?.text = "Bike Capacity: \(station.capacity)"
      return cell
    })
    
    // setup initial snapshot
    var snapshot = NSDiffableDataSourceSnapshot<Section, Station>()
    snapshot.appendSections([.primary])
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

// place in its own file
// TODO: continue to implement in order to show the
//       section header titles
// subclass UITableViewDiffableDataSource
class DataSource: UITableViewDiffableDataSource<StationsViewController.Section, Station> {
  // implement UITableViewDataSource methods here
}

