//
//  ContentView.swift
//  BetterRest
//
//  Created by Aditya Vyavahare on 24/05/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeCups = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    static var defaultWakeTime: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 00
        return Calendar.current.date(from: dateComponents) ?? .now
    }
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 5) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Pick a wake up time...", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("How many hours do you desire to sleep?")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hrs.", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("How may cups of coffee do you drink?")
                        .font(.headline)
//                    Stepper(coffeeCups == 1 ?"\(coffeeCups) cup" : "\(coffeeCups) cups", value: $coffeeCups, in: 1...20, step: 1)   //implementing ternary operator
                    ///alternative way of pluralizing
                    Stepper("^[\(coffeeCups) cup](inflect: true)", value: $coffeeCups, in: 1...20, step: 1)
                    //^[...] is a special syntax for localized formatting with inflection, meaning it will correctly handle pluralization.
                    //inflect: true ensures that the text is pluralized correctly based on the value of coffeeCups.
                }
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateSleepTime)
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("Okay") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func calculateSleepTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (dateComponents.hour ?? 0) * 60 * 60 //hour -> minute -> second
            let minute = (dateComponents.minute ?? 0) * 60 //minute -> second
            
            let sleepPrediction = try model.prediction(wake: Int64((hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(coffeeCups))
            let sleepTime = wakeUpTime - sleepPrediction.actualSleep
            
            alertTitle = "Your sleep time is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error!"
            alertMessage = """
                There was an error calculating your sleep time.
                Try again!
            """
        }
        showAlert = true
    }
}

#Preview {
    ContentView()
}
