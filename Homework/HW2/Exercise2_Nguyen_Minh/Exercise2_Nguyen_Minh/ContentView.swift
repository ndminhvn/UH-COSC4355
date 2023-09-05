//
//  ContentView.swift
//  Exercise2_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/2/23.
//

import SwiftUI

struct Topic {
    let name: String
    let iconName: String
    let contents: [String]
}

struct ContentView: View {
    @State private var selectedCard: String = "View Controller"
    @State private var cardIdx: Int = 0 {
        didSet {
            // When cardIdx changes, also update selectedCard
            selectedCard = topics[cardIdx].name
        }
    }

    @State private var isShowingSheet = false

    let topics: [Topic] = [
        Topic(name: "View Controller", iconName: "1", contents: [
            "defines the behavior for common VCs",
            "updates the content of the view",
            "responding to user interactions",
            "resizing views and layout management",
            "coordinating with other objects",
        ]),
        Topic(name: "UIKit", iconName: "2", contents: [
            "provides required iOS infrastructure",
            "window and view architecture",
            "event handling for multi-touch and etc",
            "manages interaction with system",
            "a lot of features including resource management",
        ]),
        Topic(name: "UIAlertController", iconName: "3", contents: [
            "configure alerts and action sheets",
            "intended to be used as-is",
            "does not support subclassing",
            "inherits from UIViewController",
            "support text fields to the alert interface",
        ]),
    ]

    func handleNextCard() {
        if cardIdx >= 2 {
            cardIdx = 0
        } else {
            cardIdx += 1
        }
    }

    func handleRandomCard() {
        cardIdx = Int.random(in: 0 ..< topics.count)
    }

    func handleCardSelector(name: String) {
        if let index = topics.firstIndex(where: { $0.name == name }) {
            cardIdx = index
        }
    }

    var body: some View {
        VStack {
            Text("CardHub")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 142 / 255.0, green: 66 / 255.0, blue: 53 / 255.0))

            Image(topics[cardIdx].iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)

            VStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.7451, green: 0.7686, blue: 0.8118))
                    .overlay(
                        VStack {
                            ZStack {
                                Color(red: 242 / 255.0, green: 103 / 255.0, blue: 28 / 255.0)
                                Text("Card: \(selectedCard)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(height: 40)
                            ZStack {
                                Color(red: 180 / 255.0, green: 190 / 255.0, blue: 200 / 255.0)
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(topics[cardIdx].contents, id: \.self) { content in
                                        HStack(alignment: .top) {
                                            Image(systemName: "star")
                                            Text(content)
                                                .font(.body)
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.leading)
                                                .allowsTightening(true)
                                            Spacer()
                                        }
                                        .padding(3.0)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    )
                    .padding()
                Rectangle()
                    .foregroundColor(Color.white)
                    .overlay(
                        VStack {
                            ZStack {
                                Color(red: 238 / 255.0, green: 194 / 255.0, blue: 146 / 255.0)
                                Button(action: { handleRandomCard() }) {
                                    Text("Random card")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 50)
                            ZStack {
                                Color(red: 242 / 255.0, green: 103 / 255.0, blue: 28 / 255.0)
                                Button(action: { handleNextCard() }) {
                                    Text("Next card")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 50)
                            ZStack {
                                Color(red: 142 / 255.0, green: 66 / 255.0, blue: 53 / 255.0)
                                Button(action: { isShowingSheet = true }) {
                                    Text("Card selector")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .actionSheet(isPresented: $isShowingSheet) {
                                    ActionSheet(
                                        title: Text("Pick a topic"),
                                        buttons:
                                        topics.map { topic in
                                            .default(Text(topic.name)) {
                                                handleCardSelector(name: topic.name)
                                            }
                                        } + [.cancel()]
                                    )
                                }
                            }
                            .frame(height: 50)
                            Spacer()
                        }
                    )
                    .padding([.top, .leading, .trailing])
            }
            .padding([.leading, .bottom, .trailing])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
