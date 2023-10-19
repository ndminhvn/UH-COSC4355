//
//  PeopleListView.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftUI

struct PeopleListView: View {
    @ObservedObject var peopleListVM = PeopleListViewModel()

    var body: some View {
        ZStack {
            Color(red: 241/255, green: 232/255, blue: 237/255)
            NavigationStack {
                NavigationLink(destination: FilterOptionView(peopleListVM: peopleListVM)) {
                    VStack {
                        Text("\(peopleListVM.filterType)")
                            .bold()
                            .foregroundStyle(Color.accentColor)
                        Text("somewhere near me")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color(red: 0, green: 92 / 255, blue: 139 / 255))
                    }
                    .font(.system(size: 45))
                }
                List {
                    ForEach(peopleListVM.filteredPeople(byType: peopleListVM.filterType), id: \.id) { person in
                        NavigationLink(destination: DetailView(person: person)) {
                            HStack {
                                Text(person.name)
                                    .font(.system(size: 25))
                                Spacer()
                                Text("\(person.distance) miles")
                                    .font(.system(size: 15))
                            }
                            .bold()
                            .foregroundStyle(Color(red: 0, green: 92 / 255, blue: 139 / 255))
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await peopleListVM.loadData()
                }
            }
        }
        
    }
}

#Preview {
    PeopleListView()
}
