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
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Pick a wake up time...", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Spacer()
                Text("How many hours do you desire to sleep?")
                    .font(.headline)
                Stepper("Sleep amount: \(sleepAmount.formatted()) hrs.", value: $sleepAmount, in: 4...12, step: 0.25)
                Spacer()
                Text("How may cups of coffee do you drink?")
                    .font(.headline)
                Stepper("\(coffeeCups) cups(s)", value: $coffeeCups, in: 1...20, step: 1)
                Spacer()
                Spacer()
                Spacer()
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
