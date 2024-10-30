//
//  ContentView.swift
//  BetterRepose
//
//  Created by Armando Francisco on 10/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeAmount = 1
    
    func calculateBedtime() {
            
    }
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.automatic)
                    .labelsHidden()
                    
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                    
                Stepper(coffeAmount == 1 ? "\(coffeAmount) cup" : "\(coffeAmount) cups(s)", value: $coffeAmount, in: 1...20)
            }
            .toolbar {
                Button("Calculate bedtime", action: calculateBedtime)
            }
            .navigationBarTitle("Better Repose")
        }
    }
}

#Preview {
    ContentView()
}
