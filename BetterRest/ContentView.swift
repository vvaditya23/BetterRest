//
//  ContentView.swift
//  BetterRest
//
//  Created by Aditya Vyavahare on 24/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeCups = 1
    
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
        }
    }
    
    private func calculateSleepTime() {
        
    }
}

#Preview {
    ContentView()
}
