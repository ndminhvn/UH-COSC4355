//
//  SplashView.swift
//  Exercise6_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/17/23.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            if self.isActive {
                ContentView()
            } else {
                Image("SplashScreen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(0.9)
                Text("Treasure Finder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                    .offset(y: isAnimating ? -250 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            isAnimating = true
                        }
                    }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
