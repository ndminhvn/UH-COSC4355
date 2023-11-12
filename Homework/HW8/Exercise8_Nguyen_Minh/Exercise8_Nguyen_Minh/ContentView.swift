//
//  ContentView.swift
//  Exercise8_Nguyen_Minh
//
//  Created by Minh Nguyen on 11/12/23.
//

import CoreML
import NaturalLanguage
import SwiftUI

struct ContentView: View {
    var images = ["car", "house", "people"]
    @ObservedObject var classifier: ImageClassifier

    @State var classificationText = "Classifying Image..."
    @State var classificationImageName = "car"

    var syncService = SyncService()

    var body: some View {
        TabView {
            VStack {
                Text("Pª ") // use fn + e
                    .foregroundStyle(.red)
                    .font(.system(size: 36))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
                Image(classificationImageName)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .border(.red, width: 4)
                    .onAppear {
                        classifier.detectObj(uiImage: UIImage(named: classificationImageName)!)
                        syncService.sendMessage("mood", "\(analyzeSentiment(text: classifier.imageClass!))", { _ in })
                    }
                    .onTapGesture {
                        // get random element from array excluding current
                        classificationImageName = (images.filter { $0 != classificationImageName }).randomElement()!
                        classifier.detectObj(uiImage: UIImage(named: classificationImageName)!)
                        syncService.sendMessage("mood", "\(analyzeSentiment(text: classifier.imageClass!))", { _ in })
                    }
                Spacer()
                Group {
                    if let imageClass = classifier.imageClass {
                        HStack {
                            Text("Objects:")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                            Spacer()
                            Text(imageClass)
                                .bold()
                                .lineLimit(7)
                        }
                        .foregroundStyle(.red)
                    } else {
                        HStack {
                            Text("Unable to identify objects")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.red)
                    }
                }
                .font(.subheadline)
                .padding()
                Spacer()
                // Bleeds into TabView
                Rectangle()
                    .frame(height: 0)
                    .background(.thinMaterial)
            }
            .background(.gray)
            .tabItem {
                Text("Objects identification")
                Image(systemName: "photo")
            }

            VStack {
                Text("Pª ") // use fn + e
                    .foregroundStyle(.red)
                    .font(.system(size: 36))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
                Image(classificationImageName)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .border(.red, width: 4)
                    .onAppear {
                        classifier.detectTxt(uiImage: UIImage(named: classificationImageName)!)
                        syncService.sendMessage("mood", "\(analyzeSentiment(text: classifier.imageText!))", { _ in })
                    }
                    .onTapGesture {
                        // get random element from array excluding current
                        classificationImageName = (images.filter { $0 != classificationImageName }).randomElement()!
                        classifier.detectTxt(uiImage: UIImage(named: classificationImageName)!)
                        syncService.sendMessage("mood", "\(analyzeSentiment(text: classifier.imageText!))", { _ in })
                    }
                Spacer()
                Group {
                    if let imageText = classifier.imageText {
                        HStack {
                            Text("Text:")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                            Text(imageText)
                                .bold()
                                .lineLimit(7)
                        }
                        .foregroundStyle(.red)
                    } else {
                        HStack {
                            Text("Unable to identify objects")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.red)
                    }
                }
                .font(.subheadline)
                .padding()
                Spacer()
                // Bleeds into TabView
                Rectangle()
                    .frame(height: 0)
                    .background(.thinMaterial)
            }
            .background(.gray)

            .tabItem {
                Text("Text recognition")
                Image(systemName: "doc.text")
            }
        }
        .accentColor(.red)
    }

    func analyzeSentiment(text: String) -> Int {
        // limit input to first 100 symbols
        let text = String(text.prefix(100))

        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentiment?.rawValue ?? "0") ?? 0

        let outputTxt = "The input: \(text) \n is "

        // sentiment analyzis is broken in the current update

//        return Int.random(in: 0 ..< 3)

        if score == 0 {
            print(outputTxt + "neutral with a score of \(score)")
            return 2

        } else if score < 0 {
            print(outputTxt + "negative with a score of \(score)")
            return 3

        } else {
            print(outputTxt + "positive with a score of \(score)")
            return 1
        }
    }
}

#Preview {
    ContentView(classifier: ImageClassifier())
}
