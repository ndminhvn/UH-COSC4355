//
//  DetailView.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftUI

struct DetailView: View {
    var person: Person
    
    var body: some View {
        TabView {
            VStack {
                Spacer()
                Text(person.name)
                    .bold()
                    .foregroundStyle(Color.accentColor)
                Spacer()
                VStack {
                    Text("Distance: \(person.distance)")
                    Text("At: \(person.location)")
                }
                .foregroundStyle(Color(red: 0, green: 92/255, blue: 139/255))
                Spacer()
                Text("You are: \(person.type)")
                    .foregroundStyle(Color(red: 0, green: 92/255, blue: 139/255))
                Spacer()
            }
            .font(.system(size: 45))
            .multilineTextAlignment(.center)
            .tabItem {
                Label("Details", systemImage: "info.square")
            }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
    }
}

//#Preview {
//    DetailView()
//}
