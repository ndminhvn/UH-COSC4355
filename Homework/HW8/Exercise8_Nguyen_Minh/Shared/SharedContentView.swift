//
//  SharedContentView.swift
//  Exercise8_Nguyen_Minh
//
//  Created by Minh Nguyen on 11/12/23.
//

import SwiftUI
import WatchConnectivity

struct SharedContentView: View {
//    @StateObject var counter = Counter()

    var labelStyle: some LabelStyle {
        #if os(watchOS)
            return IconOnlyLabelStyle()
        #else
            return DefaultLabelStyle()
        #endif
    }

    var body: some View {
        VStack {
            Text("Hello")
//            Text("\(counter.count)")
//                .font(.largeTitle)
//
//            HStack {
//                Button(action: counter.decrement) {
//                    Label("Decrement", systemImage: "minus.circle")
//                }
//                .padding()
//
//                Button(action: counter.increment) {
//                    Label("Increment", systemImage: "plus.circle.fill")
//                }
//                .padding()
//            }
//            .font(.headline)
//            .labelStyle(labelStyle)
        }
    }
}

#Preview {
    SharedContentView()
}
