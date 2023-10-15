//
//  TreasureMapView.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/15/23.
//

import MapKit
import SwiftUI

struct TreasureMapView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isIPhoneLandscape: Bool {
        verticalSizeClass == .compact && horizontalSizeClass == .compact
    }

    var isIPhoneMaxLandscape: Bool {
        verticalSizeClass == .compact && horizontalSizeClass == .regular
    }

    var treasure: Treasure

    @State private var region: MKCoordinateRegion
    @State private var placemark: CLPlacemark?
    @State private var isPinSelected: Bool = false

    init(treasure: Treasure) {
        self.treasure = treasure

        // Initialize the region based on treasure's coordinates
        _region = State(initialValue: MKCoordinateRegion(
            center: treasure.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.03,
                longitudeDelta: 0.03)
        ))
    }

    var body: some View {
        Map(initialPosition: .region(region)) {
            Marker(coordinate: treasure.coordinate, label: {
                
                VStack(alignment: .leading) {
                    Text(treasure.hint)
                        .onTapGesture(perform: {
                            isPinSelected.toggle()
                            if isPinSelected {
                                fetchPlacemark(for: treasure)
                            }
                        })
                    Text("Administrative Area: \(placemark?.administrativeArea ?? "N/A")")
                    Text("Locality: \(placemark?.locality ?? "N/A")")
                    Text("ISO Country Code: \(placemark?.isoCountryCode ?? "N/A")")
                }
                    
//                if let placemark = placemark {
//                    CalloutView(placemark: placemark)
//                }
            })
            
        }
    }
    
    private func fetchPlacemark(for treasure: Treasure) {
        let location = CLLocation(latitude: treasure.cap_lat, longitude: treasure.cap_long)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                self.placemark = placemark
            }
        }
    }
}

struct CalloutView: View {
    var placemark: CLPlacemark
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Administrative Area: \(placemark.administrativeArea ?? "N/A")")
            Text("Locality: \(placemark.locality ?? "N/A")")
            Text("ISO Country Code: \(placemark.isoCountryCode ?? "N/A")")
        }
    }
}

// #Preview {
//    TreasureMapView(treasure: <#T##Treasure#>)
// }
