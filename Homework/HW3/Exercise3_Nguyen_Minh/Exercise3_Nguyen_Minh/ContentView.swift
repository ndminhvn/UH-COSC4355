//
//  ContentView.swift
//  Exercise3_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/10/23.
//

import SwiftUI

// enum Sheet: Identifiable {
//    case addBullet
//    case editCardName
//
//    var id: Int {
//        hashValue
//    }
// }
//
// extension Sheet {
//    @ViewBuilder
//    var modalView: some View {
//        switch self {
//        case .addBullet:
//            AddBulletView(isPresented: .constant(true))
//        case .editCardName:
//            EditTopicNameView(isPresented: .constant(true))
//        }
//    }
// }

struct Topic {
    var name: String
    let iconName: String
    var contents: [String]
}

struct ContentView: View {
    @State private var cardIdx: Int = 0
    @State private var isShowingCardSelector = false
    @State private var isShowingAddBullet = false
    @State private var isShowingEditCardName = false

    @State private var topics: [Topic] = [
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
                                Button(action: { isShowingCardSelector = true }) {
                                    Text("Card selector")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .actionSheet(isPresented: $isShowingCardSelector) {
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
                            ZStack {
                                Color(red: 232 / 255.0, green: 197 / 255.0, blue: 88 / 255.0)
                                Button(action: { isShowingAddBullet = true }) {
                                    Text("Add bullet")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .sheet(isPresented: $isShowingAddBullet) {
                                    AddBulletView(isPresented: $isShowingAddBullet, topics: $topics, cardIdx: $cardIdx)
                                }
                            }
                            .frame(height: 50)
                            ZStack {
                                Color(red: 232 / 255.0, green: 197 / 255.0, blue: 88 / 255.0)
                                Button(action: { isShowingEditCardName = true }) {
                                    Text("Edit card name")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .sheet(isPresented: $isShowingEditCardName) {
                                    EditTopicNameView(isPresented: $isShowingEditCardName, topics: $topics, cardIdx: $cardIdx)
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
