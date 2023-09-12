//
//  AddBulletView.swift
//  Exercise3_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/11/23.
//

import SwiftUI

struct AddBulletView: View {
    @Binding var isPresented: Bool
    @Binding var topics: [Topic]
    @Binding var cardIdx: Int
    @State private var newBullet = ""

    var body: some View {
        VStack {
            Text("ADD BULLET")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 242 / 255.0, green: 103 / 255.0, blue: 28 / 255.0))
                .padding()
            VStack {
                Rectangle()
                    .foregroundColor(Color(red: 180 / 255.0, green: 190 / 255.0, blue: 200 / 255.0))
                    .overlay(
                        VStack {
                            ZStack {
                                Color(red: 242 / 255.0, green: 103 / 255.0, blue: 28 / 255.0)
                                Text(topics[cardIdx].name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(height: 40)
                            ZStack {
                                Color(red: 180 / 255.0, green: 190 / 255.0, blue: 200 / 255.0)
                                TextField("Enter new bullet point", text: $newBullet)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                            
                    )
                    .frame(height: 100)
                    .padding([.leading, .trailing])
                Rectangle()
                    .foregroundColor(Color.white)
                    .overlay(
                        VStack {
                            ZStack {
                                Color(red: 142 / 255.0, green: 66 / 255.0, blue: 53 / 255.0)
                                Button(action: {
                                    if !newBullet.isEmpty {
                                        topics[cardIdx].contents.append(newBullet)
                                        isPresented = false
                                    }
                                    newBullet = ""
                                }) {
                                    Text("Save")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 50)
                            ZStack {
                                Color(red: 232 / 255.0, green: 197 / 255.0, blue: 88 / 255.0)
                                Button(action: { isPresented = false }) {
                                    Text("Cancel")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 50)

                            Spacer()
                        }
                    )
                    .padding([.top, .leading, .trailing])
            }
            .padding([.leading, .bottom, .trailing])
            Spacer()
        }
    }
}

//struct AddBulletView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBulletView(isPresented: .constant(true), selectedCard: .constant("String"), bullet: "test")
//    }
//}
