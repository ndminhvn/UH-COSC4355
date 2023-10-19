//
//  PeopleListViewModel.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import Foundation

class PeopleListViewModel: ObservableObject {
    @Published var people = [Person]()
    @Published var searchText: String = ""
    @Published var filterType: String = "Everyone"
    
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
    
    //    var filteredTreasures: [Person] {
    //        guard !searchText.isEmpty else { return people }
    //        return people.filter { person in
    //            person.type.lowercased().contains(searchText.lowercased())
    //            || person.owner.lowercased().contains(searchText.lowercased())
    //            || String(person.id).lowercased().contains(searchText.lowercased())
    //        }
    //    }

}
