//
//  Classifier.swift
//  Exercise8_Nguyen_Minh
//
//  Created by Minh Nguyen on 11/12/23.
//

import CoreImage
import CoreML
import Foundation
import Vision

struct Classifier {
    private(set) var objResults: String?
    private(set) var txtResults: String?

    mutating func detectObj(ciImage: CIImage) {
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: config).model) else {
            fatalError("Failed to load ML model!")
        }

        let request = VNCoreMLRequest(model: model)

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        try? handler.perform([request])

        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }

        var classificationResultText = ""
        for result in results {
            classificationResultText += "\(Int(result.confidence * 100))% \(result.identifier)\n"
        }

        objResults = classificationResultText
        /*
         if let firstResult = results.first {
         self.results = firstResult.identifier
         }
         */
    }

    mutating func detectTxt(ciImage: CIImage) {
        let request = VNRecognizeTextRequest()

        request.recognitionLevel = .fast

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        try? handler.perform([request])

        guard let results = request.results else {
            return
        }

        let recognizedStrings = results.compactMap { result in
            result.topCandidates(1).first?.string
        }

        let classificationResultText = recognizedStrings.joined(separator: ", ")

        txtResults = classificationResultText
    }
}
