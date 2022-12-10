//
//  ContentView.swift
//  BetterRest
//
//  Created by Joseph Van Alstyne on 12/10/22.
//

import SwiftUI
import CoreML

struct ContentView: View {
	@State private var wakeUp = defaultWakeTime
	@State private var sleepAmount = 8.0
	@State private var coffeeAmount = 1
	let coffeeCups = [1, 2, 3, 4, 5, 6]
	
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showingAlert = false
	
	static var defaultWakeTime: Date {
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		return Calendar.current.date(from: components) ?? Date.now
	}
	
	var body: some View {
		NavigationView {
			Form {
				VStack(alignment: .leading) {
					Text("When would you like to wake up?")
						.font(.headline)
					
					DatePicker("Please enter a time.", selection: $wakeUp, displayedComponents: .hourAndMinute)
						.labelsHidden()
				}
				
				VStack(alignment: .leading) {
					Text("Desired amount of sleep:")
						.font(.headline)
					
					Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
				}
				
				VStack(alignment: .leading) {
					Text("Daily coffee intake:")
						.font(.headline)
					
					Picker("Please select the number of cups of coffee you will drink today.", selection: $coffeeAmount) {
						ForEach(coffeeCups, id: \.self) { number in
							Text((number == 1 ? "1 cup" : "\(number) cups")).tag(number)
						}
					}
					.pickerStyle(.menu)
					.labelsHidden()
				}
				
				Section {
					Text(calculateBedtime())
						.font(.largeTitle)
				} header: {
					Text("Recommended Bedtime")
						.font(.headline)
						.foregroundColor(.primary)
				}
			}
			.navigationTitle("BetterRest")

		}
		.alert(alertTitle, isPresented: $showingAlert) {
			Button("OK") { }
		} message: {
			Text(alertMessage)
		}
    }
	
	func calculateBedtime() -> String {
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)
			
			let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
			let hour = (components.hour ?? 0) * 60 * 60
			let minute = (components.minute ?? 0) * 60
			
			let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
			
			let sleepTime = wakeUp - prediction.actualSleep
			
			return String(sleepTime.formatted(date: .omitted, time: .shortened))
		} catch {
			alertTitle = "Error"
			alertMessage = "Sorry, there was a problem calculating your bedtime."
			showingAlert = true
		}
		
		return ""
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
