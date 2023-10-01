//
//  DetailView.swift
//  Exercise5_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/1/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isIPhoneLandscape: Bool {
        verticalSizeClass == .compact && horizontalSizeClass == .compact
    }

    var isIPhoneMaxLandscape: Bool {
        verticalSizeClass == .compact && horizontalSizeClass == .regular
    }

    var restaurant: Restaurant

    var body: some View {
        if isIPhoneMaxLandscape || isIPhoneLandscape {
            HStack {
                AsyncImage(url: URL(string: restaurant.map.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Text("Error image")
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
                Spacer()
                VStack {
                    AsyncImage(url: URL(string: restaurant.logo.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Text("Error image")
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    .frame(maxHeight: 80)
                    Spacer()
                    Text("P: \(restaurant.lots)")
                        .bold()
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(restaurant.about)
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                    Text(restaurant.phone)
                    Spacer()
                }
            }
            .padding()

        } 
//        else if isIPhoneLandscape {
//            HStack {
//                AsyncImage(url: URL(string: restaurant.map.replacingOccurrences(of: "http://", with: "https://"))) { phase in
//                    if let image = phase.image {
//                        image
//                            .resizable()
//                            .scaledToFit()
//                    } else if phase.error != nil {
//                        Text("Error image")
//                    } else {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle())
//                    }
//                }
////                .frame(maxWidth: .infinity)
//                Spacer()
//                VStack {
//                    AsyncImage(url: URL(string: restaurant.logo.replacingOccurrences(of: "http://", with: "https://"))) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable()
//                                .scaledToFit()
//                        } else if phase.error != nil {
//                            Text("Error image")
//                        } else {
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle())
//                        }
//                    }
//                    .frame(maxHeight: 80)
//                    Spacer()
//                    Text("P: \(restaurant.lots)")
//                        .bold()
//                        .font(.title2)
//                        .multilineTextAlignment(.center)
//                    Spacer()
//                    Text(restaurant.about)
//                        .multilineTextAlignment(.center)
//                        .frame(width: 300)
//                    Text(restaurant.phone)
//                    Spacer()
//                }
//            }
//            .padding()
//        } 
        else {
            VStack {
                AsyncImage(url: URL(string: restaurant.map.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Text("Error image")
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
                Spacer()
                AsyncImage(url: URL(string: restaurant.logo.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Text("Error image")
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
                .frame(maxHeight: 80)
                Spacer()
                Text("P: \(restaurant.lots)")
                    .bold()
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Spacer()
                Text(restaurant.about)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                Text(restaurant.phone)
                Spacer()
            }
            .padding()
        }
    }
}

// #Preview {
//    DetailView()
// }
