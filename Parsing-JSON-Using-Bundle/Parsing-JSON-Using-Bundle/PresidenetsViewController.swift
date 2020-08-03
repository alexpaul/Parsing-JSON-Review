//
//  ViewController.swift
//  Parsing-JSON-Using-Bundle
//
//  Created by Alex Paul on 8/3/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class PresidenetsViewController: UIViewController {
  
  enum Section { // Hashable by default
    case main // table view has only one section
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  typealias DataSource = UITableViewDiffableDataSource<Section, President>
  
  // both the SectionItemIdentifier and the ItemIdentifier needs to conform to
  // the Hashable protocol
  private var dataSource: DataSource! // nil

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    configureDataSource()
    fetchPresidents()
  }
  
  private func configureDataSource() {
    dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, president) -> UITableViewCell? in
      // configure cell
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = president.name
      cell.detailTextLabel?.text = "\(president.number)"
      return cell
    })
    
    // setup initial snapshot
    var snapshot = NSDiffableDataSourceSnapshot<Section, President>()
    snapshot.appendSections([.main])
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  private func fetchPresidents() {
    var presidents: [President] = []
    do {
      presidents = try Bundle.main.parseJSON(with: "presidents")
    } catch {
      print("error: \(error)")
    }
    
    // update the snapshot
    var snapshot = dataSource.snapshot() // query dataSource for the current snapshot
    snapshot.appendItems(presidents, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }


}

