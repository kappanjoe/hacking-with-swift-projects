//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var newOrder = OrderWrapper()
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					Picker("Select your cake type:", selection: $newOrder.order.type) {
						ForEach(Order.types.indices) {
							Text(Order.types[$0])
						}
					}
					
					Stepper("Number of cakes: \(newOrder.order.quantity)", value: $newOrder.order.quantity, in: 3...20)
				}
				
				Section {
					Toggle("Any special requests?", isOn: $newOrder.order.specialRequestEnabled.animation())
					
					if newOrder.order.specialRequestEnabled {
						Toggle("Add extra frosting", isOn: $newOrder.order.extraFrosting)
						Toggle("Add extra sprinkles", isOn: $newOrder.order.addSprinkles)
					}
				}
				
				Section {
					NavigationLink {
						AddressView(order: newOrder)
					} label: {
						Text("Delivery details")
					}
				}
			}
			.navigationTitle("Cupcake Corner")
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
