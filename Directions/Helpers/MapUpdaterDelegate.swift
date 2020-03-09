//
//  MapUpdaterDelegate.swift
//  Directions
//
//  Created by Kate Duncan-Welke on 3/6/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import MapKit

// handle updating map location when locale is changed
protocol MapUpdaterDelegate: class {
    func updateMapLocation(for: MKPlacemark)
}
