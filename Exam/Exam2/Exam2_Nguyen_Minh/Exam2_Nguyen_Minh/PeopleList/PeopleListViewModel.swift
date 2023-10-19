//
//  PeopleListViewModel.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import Foundation

class PeopleListViewModel: ObservableObject {
    @Published var people = [Person]()
    @Published var filterOptions: [String] = ["Everyone", "Friends", "Close friends", "Relatives", "Colleagues"]
    @Published var filterType: String = "Everyone"

    func changeFilter(option: String) {
        filterType = option
    }

    func filteredPeople(byType type: String) -> [Person] {
        if type == "Everyone" {
            return people
        }
        return people.filter { $0.type == type }
    }

    func loadData() async {
        let api = "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/people.json"
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedPeople = try JSONDecoder().decode([Person].self, from: data)
            DispatchQueue.main.async {
                self.people = decodedPeople
            }
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
}
