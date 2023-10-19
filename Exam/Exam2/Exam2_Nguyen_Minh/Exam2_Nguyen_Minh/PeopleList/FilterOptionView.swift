//
//  FilterOptionView.swift
//  Exam2_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftUI

struct FilterOptionView: View {
    @ObservedObject var peopleListVM: PeopleListViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("\(peopleListVM.filterType)")
                    .font(.system(size: 45))
                    .bold()
                Text("somewhere near me")
                    .font(.system(size: 45))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 0, green: 92 / 255, blue: 139 / 255))
            }
            List {
                ForEach(peopleListVM.filterOptions, id: \.self) { option in
                    Button(action: {
                        peopleListVM.changeFilter(option: option)
                        dismiss()
                    }, label: {
                        Text(option)
                            .font(.system(size: 35))
                            .bold()
                            .foregroundStyle(Color.accentColor)
                    })
                }
            }
        }
        .background(Color(red: 241/255, green: 232/255, blue: 237/255))
    }
}

// #Preview {
//    FilterOptionView()
// }
