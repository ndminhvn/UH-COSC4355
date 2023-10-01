//
//  SplashView.swift
//  Exercise5_Nguyen_Minh
//
//  Created by Minh Nguyen on 10/1/23.
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
                VStack(spacing: 2.0) {
                    Text("Restaurant Finder")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.02, brightness: 1.0))
                        .offset(y: isAnimating ? -45 : 0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isAnimating = true
                            }
                        }
                    Text("Made by Minh Nguyen")
                        .font(.title3)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.02, brightness: 1.0))
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isAnimating = true
                            }
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
