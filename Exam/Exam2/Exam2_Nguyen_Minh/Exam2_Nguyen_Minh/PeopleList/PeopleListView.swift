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
        NavigationStack {
            VStack {
                Text("\(peopleListVM.filterType)")
                    .font(.system(size: 45))
                    .bold()
                    .foregroundStyle(Color.accentColor)
                Text("somewhere near me")
                    .font(.system(size: 35))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 0, green: 92/255, blue: 139/255))
            }
            .frame(width: 300)
            List {
                ForEach(peopleListVM.people, id: \.id) { person in
                    NavigationLink(destination: DetailView(person: person)) {
                        HStack {
                            Text(person.name)
                                .font(.system(size: 25))
                            Spacer()
                            Text("\(person.distance) miles")
                                .font(.system(size: 15))
                        }
                        .bold()
                        .foregroundStyle(Color(red: 0, green: 92/255, blue: 139/255))
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

#Preview {
    PeopleListView()
}
