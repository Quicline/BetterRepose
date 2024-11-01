//
//  ContentView.swift
//  BetterRepose
//
//  Created by Armando Francisco on 10/29/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeAmount = 1
    
    //@State private var alertTile = ""
    //@State private var alertMessage = ""
    //@State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
        
    }
    
    private var calculateBedtime: (title: String, message: String) {
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            //alertTile = "Your ideal bedtime is..."
            
            //alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            //showingAlert = true
            
            return ("Your ideal bedtime is...", sleepTime.formatted(date: .omitted, time: .shortened))
        } catch {
            
            //alertTile = "Error"
            //alertMessage = "Sorry there was an error calculating your bedtime:\(error)"
            return ("Error", "Sorry there was an error calculating your bedtime:\(error)")
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    //Text("When do you want to wake up?")
                    //  .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.automatic)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    //Text("Desired amount of sleep")
                    //  .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    //Text("Daily coffee intake")
                    //  .font(.headline)
                    
                    Picker("Coffee intake", selection: $coffeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    //Stepper("^[\(coffeAmount) cup](inflect: true)", value: $coffeAmount, in: 1...20)
                }
                
                VStack {
                    HStack {
                        Text("\(calculateBedtime.title)\n")
                            .font(.title3)
                    }
                    HStack {
                        Spacer()
                        Text("\(calculateBedtime.message)")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                }
            }
            
            .navigationBarTitle("Better Repose")
//            .toolbar {
//            Button("Calculate bedtime", action: calculateBedtime)
//            }
//            .alert(alertTile, isPresented: $showingAlert) {
//                Button("OK") {
//                    
//                }
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
}

#Preview {
    ContentView()
}
