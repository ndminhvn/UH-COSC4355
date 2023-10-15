//
//  DataModel.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/15/23.
//

import Foundation
import MapKit

struct Treasure: Codable, Identifiable {
    var id: Int
    var value: Int
    var type: String
    var owner: String
    var hint: String
    var cap_lat: Double
    var cap_long: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: cap_lat, longitude: cap_long)
    }
}
