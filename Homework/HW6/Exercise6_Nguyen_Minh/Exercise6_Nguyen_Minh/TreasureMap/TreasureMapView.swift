//
//  TreasureMapView.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/15/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct Place: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
}

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
    @State private var places: [Place]
    @State private var selectedItem: String?
    @State private var nextPlaceID: Int = 1
    @State private var longPressLocation = CGPoint.zero
    @State private var cameraPosition: MapCameraPosition
    @State private var placeSubtitle: String = ""

    init(treasure: Treasure) {
        self.treasure = treasure
        let place = Place(id: String(treasure.id), name: treasure.hint, coordinate: treasure.coordinate)

        _cameraPosition = State(initialValue: .camera(
            MapCamera(centerCoordinate: treasure.coordinate, distance: 10000)
        ))

        _places = State(initialValue: [place])
    }

    func longPressDrag(reader: MapProxy) -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            .onEnded { value in
                switch value {
                case .second(true, let drag):
                    longPressLocation = drag?.location ?? .zero
                    let newPin: CLLocationCoordinate2D = reader.convert(longPressLocation, from: .local)!
                    let newPlace = Place(id: "\(nextPlaceID)", name: "Pin #\(nextPlaceID)", coordinate: newPin)

                    if places.count > 0 {
                        // Check if the long press is on the treasure pin
                        let distance = calculateDistance(from: treasure.coordinate, to: newPin)
                        let thresholdDistance: CLLocationDistance = 100

                        if distance <= thresholdDistance {
                            fetchPlacemark(for: treasure)
                            return
                        } else {
                            places.append(newPlace)
                            nextPlaceID += 1
                        }
                    }

                default:
                    break
                }
            }
    }

    func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)

        return location1.distance(from: location2)
    }

    var body: some View {
        MapReader { reader in
            Map(position: $cameraPosition, interactionModes: .all, selection: $selectedItem) {
                ForEach(places, id: \.id) { place in
                    if place.name.count > 6 {
                        Marker(coordinate: place.coordinate, label: {
                            Text(place.name)
                                + Text("\n\(placeSubtitle)")
                        }).tag(place.id)
                    } else {
                        Marker(coordinate: place.coordinate, label: {
                            Text(place.name)
                        }).tag(place.id)
                    }
                }
            }
            .gesture(longPressDrag(reader: reader))
        }
    }

    private func fetchPlacemark(for treasure: Treasure) {
        let location = CLLocation(latitude: treasure.cap_lat, longitude: treasure.cap_long)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                self.placeSubtitle = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.isoCountryCode ?? "")"
            }
        }
    }
}

// #Preview {
//    TreasureMapView(treasure: <#T##Treasure#>)
// }
