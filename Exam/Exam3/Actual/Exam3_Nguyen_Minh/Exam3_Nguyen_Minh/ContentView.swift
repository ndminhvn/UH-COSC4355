//
//  ContentView.swift
//  Exam3_Nguyen_Minh
//
//  Created by Minh Nguyen on 11/16/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @ObservedObject var classifier: ImageClassifier
    @State private var filter: String = "Original"
    @State private var sliderValue: Double = 0
    var filters = ["Original", "Blur", "Binarized"]

    @State private var image: UIImage? = UIImage(named: "sample1")
    @State private var filteredImage: UIImage?
    var images = ["sample1", "sample2", "sample3"]

    @State private var classificationText = "Classifying Image..."
    @State private var classificationImageName = "sample1" {
        didSet {
            image = UIImage(named: classificationImageName)
        }
    }

    @State private var intensity = 0.25
    let context = CIContext()

    var syncService = SyncService()

    var body: some View {
        VStack {
            Text("TXT Recognition vs Image Filters")
                .font(.custom("American Typewriter", size: 20))
                .padding(.vertical)
            Picker("", selection: $filter) {
                ForEach(filters, id: \.self) {
                    Text($0).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: filter) {
                filteredImage = filterImage(inputImg: image, filter: filter)
                if filter == "Original" {
                    filteredImage = image
                }
                sliderValue = 0
            }
            .padding()

            // Image
            if let image = image {
                Image(uiImage: filteredImage ?? image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    .onAppear {
                        classifier.detectTxt(uiImage: UIImage(named: classificationImageName)!)
                        //                    syncService.sendMessage("mood", "\(analyzeImage(text: classifier.imageClass!))", { _ in })
                    }
                    .onTapGesture {
                        // get random element from array excluding current
                        filter = "Original"
                        classificationImageName = (images.filter { $0 != classificationImageName }).randomElement()!
                        filteredImage = nil
                        classifier.detectTxt(uiImage: UIImage(named: classificationImageName)!)
                        //                    syncService.sendMessage("mood", "\(analyzeImage(text: classifier.imageClass!))", { _ in })
                    }
                    .onChange(of: sliderValue) {
                        filteredImage = filterImage(inputImg: image, filter: filter)
                        if filter == "Original" {
                            filteredImage = image
                        }

                        if let filteredImage {
                            classifier.detectTxt(uiImage: filteredImage)
                        }
                    }
            }

            HStack(alignment: .center) {
                Button(action: {
                    // get random element from array excluding current
                    filter = "Original"
                    classificationImageName = (images.filter { $0 != classificationImageName }).randomElement()!
                    filteredImage = nil
                    classifier.detectTxt(uiImage: UIImage(named: classificationImageName)!)
                    //                    syncService.sendMessage("mood", "\(analyzeImage(text: classifier.imageClass!))", { _ in })
                }, label: {
                    Image(systemName: "photo.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.accentColor)
                })

                VStack {
                    if filter != "Original" {
                        Slider(value: $sliderValue, in: 0 ... 1)
                        Text("\(sliderValue * 100, specifier: "%.1f")%")
                    } else {
                        Slider(value: $sliderValue, in: 0 ... 300).disabled(true)
                    }
                }
            }
            .frame(maxWidth: 250)
            .padding()
            if let imageText = classifier.imageText {
                if imageText == "" {
                    Text("Unable to identify text.")
                        .fontWeight(.medium)
                        .padding()
                } else {
                    Text(imageText)
                        .lineLimit(7)
                        .multilineTextAlignment(.center)
                        .padding()
                        .onChange(of: imageText) {
                            syncService.sendMessage("array", analyzeText(text: imageText)) { _ in
                            }
                        }
                }
            }
            Spacer()
        }
        .padding()
    }

    // Image filter
    private func getFilter(filter: String, inputImage: CIImage) -> CIFilter {
        if filter == "Binarized" {
            let binarizeFilter = CIFilter(name: "CIColorControls")!
            binarizeFilter.setValue(inputImage, forKey: kCIInputImageKey)
            binarizeFilter.setValue(0.0, forKey: kCIInputSaturationKey)
            binarizeFilter.setValue(0.5 * sliderValue, forKey: kCIInputBrightnessKey)

            return binarizeFilter
        }
        return CIFilter(name: "CIGaussianBlur", parameters: ["inputImage": inputImage, "inputRadius": 100 * sliderValue])!
    }

    // Filtered image
    private func filterImage(inputImg: UIImage?, filter: String) -> UIImage? {
        guard let inputImg = inputImg,
              let inputCIImage = CIImage(image: inputImg) else { return nil }

        let filter = getFilter(filter: filter, inputImage: inputCIImage)

        guard let ciImageResult = filter.outputImage else { return nil }

        if let cgImage = context.createCGImage(ciImageResult, from: ciImageResult.extent) {
            let originalOrientation = inputImg.imageOrientation
            let originalScale = inputImg.scale
            return UIImage(cgImage: cgImage, scale: originalScale, orientation: originalOrientation)
        }

        return nil
    }

    func analyzeText(text: String) -> [String] {
        // limit input to first 100 symbols
        let text = String(text.prefix(100)).lowercased()
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        // Create a dictionary to store word frequencies
        var wordFrequencies: [String: Int] = [:]

        // Count the frequency of each word
        for word in words {
            let cleanedWord = word.lowercased().trimmingCharacters(in: .punctuationCharacters)
            if !cleanedWord.isEmpty {
                wordFrequencies[cleanedWord, default: 0] += 1
            }
        }

        // Sort the dictionary by frequency in descending order
        let sortedWords = wordFrequencies.sorted { $0.value > $1.value }

        // Take the top 3 words
        let topWords = Array(sortedWords.prefix(3)).map { $0.key }
        print(topWords)

        return topWords
    }
}

#Preview {
    ContentView(classifier: ImageClassifier())
}
