//
//  ContentView.swift
//  Exercise8_Nguyen_Minh Watch App
//
//  Created by Minh Nguyen on 11/13/23.
//

import SwiftUI

struct ContentView: View {
    private var syncService = SyncService()
    @State private var receivedData: [String] = []
    var icons = ["❓", "🚗", "💻", "🏠"]
    @State var iconIdx = 0
    
    var body: some View {
        VStack {
            Text("Pª ") // use fn + e
                .foregroundStyle(.red)
                .font(.system(size: 36))
                .bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text(icons[iconIdx])
                .font(.system(size: 80))
            
            // Bleeds into TabView
            Rectangle()
                .frame(height: 0)
                .background(.thinMaterial)
        }
        .background(.gray)
        .onAppear { syncService.dataReceived = Receive }
    }
    
    private func Receive(key: String, value: Any) -> Void {
        self.receivedData.append("\(Date().formatted(date: .omitted, time: .standard)) - \(key):\(value)")
        self.iconIdx = Int("\(value)") ?? 0
    }
}

#Preview {
    ContentView()
}
