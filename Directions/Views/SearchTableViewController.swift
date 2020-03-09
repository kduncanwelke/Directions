//
//  SearchTableViewController.swift
//  Directions
//
//  Created by Kate Duncan-Welke on 3/5/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController {
    
    // MARK: Variables
    
    var resultsList: [MKMapItem] = [MKMapItem]()
    var mapView: MKMapView? = nil
    var selected = 0
    
    // delegate to pass search back to view controller
    weak var delegate: MapUpdaterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set up table view qualities
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.rowHeight = 70.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "searchCell")
        
        // get map placemark and details
        let selectedItem = resultsList[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        
        // parse address to show in cell
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.detailTextLabel?.text = LocationManager.parseAddress(selectedItem: selectedItem)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = resultsList[indexPath.row].placemark
        
        if selected == 0 {
            // pass coordinates into search object
            Locations.startPlaceMark = selectedLocation
        } else if selected == 1 {
            Locations.endPlaceMark = selectedLocation
        }
       
        // update location on map when back in earth view controller
        delegate?.updateMapLocation(for: selectedLocation)
        
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        if searchController.searchBar.tag == 0 {
            selected = 0
            print("first")
        } else if searchController.searchBar.tag == 1 {
            selected = 1
            print("second")
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, _ in
            guard let response = response else {
                return
            }
           
            self?.resultsList = response.mapItems
            self?.tableView.reloadData()
        }
    }
    
}
