//
//  ContentView.swift
//  Exercise7_Nguyen_Minh Watch App
//
//  Created by Minh Nguyen on 10/29/23.
//

import HealthKit
import SwiftUI

struct ContentView: View {
    private var healthStore = HKHealthStore()
    @State private var value = 0
    let heartRateQuantity = HKUnit(from: "count/min")

    var body: some View {
        VStack {
            Button(action: {
                createWorkoutEmulation()
                startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            }) {
                Text("❤️")
                    .font(.system(size: 50))
                    .cornerRadius(36)
            }

            HStack {
                Text("\(value)")
                    .font(.system(size: 70))

                Text("BPM")
                    .font(.headline)
                    .font(.system(size: 28))
                    .bold()
                    .baselineOffset(30.0)
                    .foregroundStyle(Color.red)
                Spacer()
            }
        }
        .padding()
        .onAppear(perform: start)
    }

    func start() {
        authorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }

    func authorizeHealthKit() {
        // Used to define the identifiers that create quantity type objects.
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        // Requests permission to save and read the specified data types.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }

    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])

        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            _, samples, _, _, _ in

            guard let samples = samples as? [HKQuantitySample] else {
                return
            }

            self.process(samples, type: quantityTypeIdentifier)
        }

        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)

        query.updateHandler = updateHandler
        healthStore.execute(query)
    }

    private func createWorkoutEmulation() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor

        var session: HKWorkoutSession!
        var builder: HKWorkoutBuilder!

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session.associatedWorkoutBuilder()
        } catch {
            return
        }
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { _, _ in
        }
    }

    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0

        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            }

            value = Int(lastHeartRate)
        }
    }
}

#Preview {
    ContentView()
}
