//
//  ContentView.swift
//  WeSplit
//
//  Created by Joseph Van Alstyne on 12/9/22.
//

import SwiftUI

struct ContentView: View {
	@State private var checkAmount = 0.0
	@State private var peopleIndex = 2
	@State private var tipPercentage = 20
	let tipPercentages = [10, 15, 20, 25, 0]
	
	@State private var grandTotal = 0.0
	var didNotTip: Bool {
		return tipPercentage == 0
	}
	var totalPerPerson: Double {
		let peopleCount = Double(peopleIndex + 2)
		let tipSelection = Double(tipPercentage)
		
		let tipValue = checkAmount / 100 * tipSelection
		grandTotal = checkAmount + tipValue
		let amountPerPerson = grandTotal / peopleCount
		
		return amountPerPerson
	}
	
	let currency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "JPY")
	
	@FocusState private var amountIsFocus: Bool
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Amount", value: $checkAmount, format: currency)
						.keyboardType(.decimalPad)
						.focused($amountIsFocus)
				} header: {
					Text("Check total:")
				}
				
				Section {
					Picker("", selection: $peopleIndex) {
						ForEach(2..<100) {
							Text("\($0) people")
						}
					}
				} header: {
					Text("Number of people:")
				}
				
				Section {
					Picker("", selection: $tipPercentage) {
						ForEach(tipPercentages, id: \.self) {
							Text($0, format: .percent)
						}
					}
					.pickerStyle(.segmented)
				} header: {
					Text("Tip percentage:")
				}
				
				Section {
					GrandTotalText(didNotTip: didNotTip, grandTotal: grandTotal, currency: currency)
				} header: {
					Text("Check total w/ tip:")
				}
				.headerProminence(.increased)
				
				Section {
					Text(totalPerPerson, format: currency)
				} header: {
					Text("Amount owed per person:")
				}
				.headerProminence(.increased)
			}
			.navigationTitle("WeSplit")
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					
					Button("Done") {
						amountIsFocus = false
					}
				}
			}
		}
	}
}

struct GrandTotalText: View {
	
	var didNotTip: Bool
	var grandTotal: Double
	let currency: FloatingPointFormatStyle<Double>.Currency
	
	var body: some View {
		if didNotTip {
			return Text("Maybe consider a tip?")
		} else {
			return Text(grandTotal, format: currency)
		}
		// I tried to make this work with just a conditional property instead of returning a whole new view but I couldn't figure out how to keep the currency formatting alongside the text String 🙃
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
