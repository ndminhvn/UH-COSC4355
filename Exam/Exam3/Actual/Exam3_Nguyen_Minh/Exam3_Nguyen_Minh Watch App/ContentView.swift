//
//  ContentView.swift
//  Exam3_Nguyen_Minh Watch App
//
//  Created by Minh Nguyen on 11/16/23.
//

import SwiftUI

struct ContentView: View {
    private var syncService = SyncService()
    @State private var receivedData: [String] = []

    var body: some View {
        Text("Top 3 words recognized")
            .multilineTextAlignment(.center)
        ForEach(receivedData, id: \.self) { data in
            Text(data)
                .fontWeight(.medium)
        }
        .onAppear { syncService.dataReceived = Receive }
    }
    
    private func Receive(key: String, value: [String]) {
        receivedData = value
    }
}

#Preview {
    ContentView()
}
