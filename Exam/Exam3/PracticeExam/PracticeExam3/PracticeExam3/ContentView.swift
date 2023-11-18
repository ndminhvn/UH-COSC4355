//
//  ContentView.swift
//  PracticeExam3
//
//  Created by Minh Nguyen on 11/16/23.
//

import PhotosUI
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @ObservedObject var classifier: ImageClassifier
    @State private var filter: String = "Original"
    @State private var sliderValue: Double = 0
    var filters = ["Original", "Blur", "Binarized", "Sepia"]

    @State private var photoItem: PhotosPickerItem?
    @State private var image: UIImage?

    @State var classificationText = "Classifying Image..."
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()

    var body: some View {
        VStack {
            Text("ML Model vs Image Filters")
                .font(.custom("American Typewriter", size: 24))
                .padding(.vertical)
            Picker("", selection: $filter) {
                ForEach(filters, id: \.self) {
                    Text($0).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            if let image {
                Image(uiImage: applyFilter(to: image))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding(.vertical)
                    .onAppear {
                        classifier.detectObj(uiImage: image)
//                        syncService.sendMessage("mood", "\(analyzeImage(text: classifier.imageText!))", { _ in })
                    }
            } else {
                Color.gray.opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .padding(.vertical)
            }

            HStack(alignment: .center) {
                PhotosPicker(selection: $photoItem) {
                    Image(systemName: "photo.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.accentColor)
                }
                .onChange(of: photoItem) {
                    Task {
                        if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                image = uiImage
                                return
                            }
                        }
                        print("Failed to select image")
                    }
                }
                VStack {
                    Slider(value: $sliderValue, in: 0 ... 300)
                    Text("\(sliderValue, specifier: "%.1f")")
                }
            }
            .frame(maxWidth: 250)
            .padding()
            if let imageClass = classifier.imageClass {
                Text(imageClass)
                    .lineLimit(7)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Unable to identify objects")
                    .font(.system(size: 26))
                    .fontWeight(.semibold)
                    .padding()
            }
            Spacer()
        }
        .padding()
    }
    
    private func applyFilter(to image: UIImage) -> UIImage {
        switch filter {
            case "Original":
                return image
            case "Blur":
                return applyBlur(to: image)
            case "Binarized":
                return applyBinarized(to: image)
            case "Sepia":
                return applySepia(to: image)
            default:
                return image
        }
    }
    
    private func applyBlur(to image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = ciImage
        blurFilter.radius = 100
        
        if let outputImage = blurFilter.outputImage {
            return UIImage(ciImage: outputImage)
        } else {
            return image
        }
    }
    
    private func applyBinarized(to image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        let blurFilter = CIFilter.colorThreshold()
        blurFilter.inputImage = ciImage
        blurFilter.threshold = 10
        
        if let outputImage = blurFilter.outputImage {
            return UIImage(ciImage: outputImage)
        } else {
            return image
        }
    }
    
    private func applySepia(to image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        let blurFilter = CIFilter.sepiaTone()
        blurFilter.inputImage = ciImage
        blurFilter.intensity = 0.5
        
        if let outputImage = blurFilter.outputImage {
            return UIImage(ciImage: outputImage)
        } else {
            return image
        }
    }
}

#Preview {
    ContentView(classifier: ImageClassifier())
}
