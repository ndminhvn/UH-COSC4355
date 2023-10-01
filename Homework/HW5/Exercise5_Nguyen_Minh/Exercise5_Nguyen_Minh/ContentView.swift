//
//  ContentView.swift
//  Exercise5_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var restaurants = [Restaurant]()
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ForEach(restaurants, id: \.name) { restaurant in
                        Divider()
                        NavigationLink(destination: DetailView(restaurant: restaurant)) {
                            HStack {
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
                                Text(restaurant.free)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                loadData()
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func loadData() {
        let api = "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/restaurant/restaurants.json"
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }

        isLoading = true

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedRestaurants = try JSONDecoder().decode([Restaurant].self, from: data)

                DispatchQueue.main.async {
                    restaurants = decodedRestaurants
                    isLoading = false
                }
            } catch {
                print("Error loading data: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}

// #Preview {
//    ContentView()
//
//    ContentView()
//        .previewInterfaceOrientation(.landscapeLeft)
// }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
