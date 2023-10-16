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
    @State private var annotationSubTitle: String = ""

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
//            Marker(coordinate: treasure.coordinate, label: {
//                //                    Text("\(treasure.hint)\n\(placemark?.locality ?? "")\n\(placemark?.administrativeArea ?? "")\n\(placemark?.isoCountryCode ?? "")")
//                Text("")
//            })
            Annotation(treasure.hint, coordinate: treasure.coordinate) {
                VStack {
                    ZStack {
//                        Circle()
//                            .fill(
//                                RadialGradient(
//                                    gradient: Gradient(colors: [Color(red: 253 / 255, green: 110 / 255, blue: 114 / 255), Color(red: 241 / 255, green: 89 / 255, blue: 93 / 255), Color(red: 211 / 255, green: 64 / 255, blue: 67 / 255)]),
//                                    center: .center,
//                                    startRadius: 0,
//                                    endRadius: 20
//                                )
//                            )
//                            .frame(width: 30, height: 30)
//                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 4)
                        Image("MarkerIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 4)

                        Image(systemName: "mappin")
                            .foregroundColor(.white)
                            .shadow(color: Color.white.opacity(0.5), radius: 10, x: 0, y: 4)
                    }
                    Text(annotationSubTitle)
                        .font(.caption2)
                }
                .multilineTextAlignment(.center)
                .frame(width: 130)
                .onTapGesture {
                    fetchPlacemark(for: treasure)
                }
            }
        }
    }

    private func fetchPlacemark(for treasure: Treasure) {
        let location = CLLocation(latitude: treasure.cap_lat, longitude: treasure.cap_long)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                self.placemark = placemark
                self.annotationSubTitle = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.isoCountryCode ?? "")"
            }
        }
    }
}

// #Preview {
//    TreasureMapView(treasure: <#T##Treasure#>)
// }
