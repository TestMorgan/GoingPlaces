//
//  HistoryTableViewController.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/6/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import UIKit

/// History table view controller.
final class HistoryTableViewController: UITableViewController {

    var placeDataManager: PlaceDataManager?

    private let dateFormatter = DateFormatter()
    private var places: [Place] = []
    private let dateFormat = "MM/dd/yyyy hh:mm"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        dateFormatter.dateFormat = dateFormat
        
        if let places = placeDataManager?.getPlaces() {
            self.places = places
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)

        let place = places[indexPath.row]
        cell.textLabel?.text = place.address
        
        let date = Date(timeIntervalSince1970: place.createdUTC)
        cell.detailTextLabel?.text = "Sent & shared by \(place.from!) to \(place.to!) at \(dateFormatter.string(from: date))"

        return cell
    }

}

extension HistoryTableViewController: Identifiable {
    
    static var identifier: String = "HistoryTableViewController"
    static var parentStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

