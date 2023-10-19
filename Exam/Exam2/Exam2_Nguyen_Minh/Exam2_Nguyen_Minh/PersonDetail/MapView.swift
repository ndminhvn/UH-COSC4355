//
//  MapView.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    var person: Person
    @State private var cameraPosition: MapCameraPosition

    init(person: Person) {
        self.person = person
        _cameraPosition = State(initialValue: .camera(
            MapCamera(centerCoordinate: person.coordinate, distance: 1000)
        ))
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            Marker(coordinate: person.coordinate) {
                Text("\(person.name) is here!")
            }
            .tint(.orange)
        }
    }
}

//#Preview {
//    MapView()
//}
