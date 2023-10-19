//
//  DataModel.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import Foundation
import MapKit

struct Person: Codable, Identifiable {
    let id: Int
    let distance: Int
    let type: String
    let name: String
    let location: String
    let lati: Double
    let longi: Double
}

extension Person {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lati, longitude: longi)
    }
}
