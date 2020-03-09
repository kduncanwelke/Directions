//
//  ViewController.swift
//  Directions
//
//  Created by Kate Duncan-Welke on 3/5/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var fromSearchBox: UIView!
    @IBOutlet weak var toSearchBox: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Variables
    
    var startSearchController = UISearchController(searchResultsController: nil)
    var endSearchController = UISearchController(searchResultsController: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set up search bar
        let resultsTableController = SearchTableViewController()
        resultsTableController.mapView = mapView
        resultsTableController.delegate = self
        
        startSearchController = UISearchController(searchResultsController: resultsTableController)
        startSearchController.searchBar.searchBarStyle = .minimal
        fromSearchBox.addSubview(startSearchController.searchBar)
        
        startSearchController.searchResultsUpdater = resultsTableController
        startSearchController.delegate = self
        startSearchController.searchBar.delegate = self // Monitor when the search button is tapped.
        startSearchController.searchBar.placeholder = "Type to find a start location . . ."
        startSearchController.searchBar.tag = 0
        
        endSearchController = UISearchController(searchResultsController: resultsTableController)
        endSearchController.searchBar.searchBarStyle = .minimal
        toSearchBox.addSubview(endSearchController.searchBar)
        
        endSearchController.searchResultsUpdater = resultsTableController
        endSearchController.delegate = self
        endSearchController.searchBar.delegate = self // Monitor when the search button is tapped.
        endSearchController.searchBar.placeholder = "Type to find a destination . . ."
        endSearchController.searchBar.tag = 1
    }
    
    func addPin(latitude: Double, longitude: Double, name: String) {
        // wipe annotations if location was updated
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let regionRadius: CLLocationDistance = 10000
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        let annotation = MKPointAnnotation()
        
        annotation.title = name
        
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }

    func updateLocation(location: MKPlacemark) {
        
        if let start = Locations.startPlaceMark, let name = start.title {
            mapView.removeAnnotations(mapView.annotations)
            startSearchController.searchBar.text = name
            addPin(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude, name: name)
            print(start.coordinate.latitude)
            print(start.coordinate.longitude)
        }
        
        if let end = Locations.endPlaceMark, let name = end.title {
            endSearchController.searchBar.text = name
            addPin(latitude: end.coordinate.latitude, longitude: end.coordinate.longitude, name: name)
            print(end.coordinate.latitude)
            print(end.coordinate.longitude)
        }
       
        guard let start = Locations.startPlaceMark, let end = Locations.endPlaceMark else { return }
        
        let startCoord = CLLocation(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude)
        let endCoord = CLLocation(latitude: end.coordinate.latitude, longitude: end.coordinate.longitude)
        
        let distance = startCoord.distance(from: endCoord)
        
        let regionRadius: CLLocationDistance = distance * 1.3
        
        let middleLat = (start.coordinate.latitude + end.coordinate.latitude)/2
        let middleLon = (start.coordinate.longitude + end.coordinate.longitude)/2
        
        let center = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLon)
         
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
    }

}

extension ViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    // function needed to satisfy compiler
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension ViewController: MapUpdaterDelegate {
    // delegate used to pass location from search
    func updateMapLocation(for location: MKPlacemark) {
        updateLocation(location: location)
    }
}
