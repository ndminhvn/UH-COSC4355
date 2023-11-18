//
//  PracticeExam3App.swift
//  PracticeExam3
//
//  Created by Minh Nguyen on 11/16/23.
//

import SwiftUI

@main
struct PracticeExam3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(classifier: ImageClassifier())
        }
    }
}
