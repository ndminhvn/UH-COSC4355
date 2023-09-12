//
//  SplashView.swift
//  Exercise3_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/10/23.
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
                    .padding(.trailing, 75)
                    .ignoresSafeArea()
                VStack(spacing: 2.0) {
                    Text("CardHub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 200 / 255.0, green: 80 / 255.0, blue: 80 / 255.0))
                        .offset(y: isAnimating ? -45 : 0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isAnimating = true
                            }
                        }
                    Text("Made by Minh Nguyen")
                        .font(.title3)
                        .foregroundColor(Color(red: 1800 / 255.0, green: 80 / 255.0, blue: 80 / 255.0))
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

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
