//
//  TreasuresListView.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/15/23.
//

import SwiftUI

struct TreasuresListView: View {
    @StateObject var viewModel = TreasureListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredTreasures, id: \.id) { treasure in
                    ZStack(alignment: .center) {
                        NavigationLink(
                            destination: TreasureMapView(treasure: treasure)) {
                                EmptyView()
                            }
                            .opacity(0)
                        VStack {
                            Text("\(treasure.type) #\(treasure.id)")
                            Text(treasure.owner)
                        }
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                    }
                    .listRowBackground(viewModel.treasureColor(treasure.value))
                }
                .onDelete(perform: { indexSet in
                    viewModel.deleteTreasure(at: indexSet)
                })
                .listRowSeparator(.hidden, edges: .all)
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText)
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
        }
    }
}

#Preview {
    TreasuresListView()
}
