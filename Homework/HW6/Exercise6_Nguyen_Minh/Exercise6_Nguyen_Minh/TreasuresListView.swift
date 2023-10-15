//
//  TreasuresListView.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/15/23.
//

import SwiftUI

struct TreasuresListView: View {
    @State private var treasures = [Treasure]()
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List($treasures, id: \.id, editActions: .delete) { $treasure in
                ZStack(alignment: .leading) {
                    NavigationLink(
                        destination: TreasureMapView(treasure: treasure)) {
                            EmptyView()
                        }
                        .opacity(0)

                    HStack {
                        Spacer()
                        VStack {
                            Text("\(treasure.type) #\(treasure.id)")
                            Text(treasure.owner)
                        }
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        Spacer()
                    }
                }
                .listRowBackground(treasureColor(treasure.value))
            }
            .listStyle(PlainListStyle())
            .onAppear {
                loadData()
            }
            .padding(.top, 30)
        }

//        NavigationStack {
//            ScrollView {
//                if isLoading {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    VStack(spacing: 0) {
//                        ForEach($treasures, id: \.id, editActions: .delete) { $treasure in
//                            NavigationLink(destination: TreasureMapView(treasure: treasure)) {
//                                HStack {
//                                    Spacer()
//                                    VStack {
//                                        Text("\(treasure.type) #\(treasure.id)")
//                                        Text(treasure.owner)
//                                    }
//                                    .font(.title2)
//                                    .foregroundStyle(Color.black)
//                                    .padding()
//                                    Spacer()
//                                }
//                            }
//
//                            .background(treasureColor(treasure.value))
//                            Divider()
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                loadData()
//            }
//            .padding(.top, 30)
//        }
    }

    func loadData() {
        let api = "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/treasures.json"
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }

        isLoading = true

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedTreasures = try JSONDecoder().decode([Treasure].self, from: data)

                DispatchQueue.main.async {
                    treasures = decodedTreasures
                    isLoading = false
                }
            } catch {
                print("Error loading data: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }

    func treasureColor(_ value: Int) -> Color {
        if value > 50 {
            return Color(red: 255 / 255.0, green: 215 / 255.0, blue: 0, opacity: Double(value) / 100)
        }
        return Color(red: 255 / 255.0, green: 215 / 255.0, blue: 0, opacity: Double(value - 30) / 100)
    }
}

#Preview {
    TreasuresListView()
}
