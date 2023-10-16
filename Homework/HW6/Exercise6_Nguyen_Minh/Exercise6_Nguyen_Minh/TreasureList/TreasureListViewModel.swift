//
//  TreasureListViewModel.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/16/23.
//

import Foundation
import SwiftUI

class TreasureListViewModel: ObservableObject {
    @Published var treasures = [Treasure]()
    @Published var searchText: String = ""

    func loadData() async {
        let api = "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/treasures.json"
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedTreasures = try JSONDecoder().decode([Treasure].self, from: data)
            DispatchQueue.main.async {
                self.treasures = decodedTreasures
            }
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }

    var filteredTreasures: [Treasure] {
        guard !searchText.isEmpty else { return treasures }
        return treasures.filter { treasure in
            treasure.type.lowercased().contains(searchText.lowercased())
                || treasure.owner.lowercased().contains(searchText.lowercased())
                || String(treasure.id).lowercased().contains(searchText.lowercased())
        }
    }

    func treasureColor(_ value: Int) -> Color {
        if value > 50 {
            return Color(red: 255 / 255.0, green: 215 / 255.0, blue: 0, opacity: Double(value) / 100)
        }
        return Color(red: 255 / 255.0, green: 215 / 255.0, blue: 0, opacity: Double(value - 30) / 100)
    }

    func deleteTreasure(at offsets: IndexSet) {
        treasures.remove(atOffsets: offsets)
    }
}
