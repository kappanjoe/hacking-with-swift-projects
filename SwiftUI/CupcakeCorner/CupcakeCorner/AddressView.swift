//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

struct AddressView: View {
	@ObservedObject var currentOrder: OrderWrapper
	
	var body: some View {
		Form {
			Section {
				TextField("Name", text: $currentOrder.order.name)
				TextField("Mailing Address", text: $currentOrder.order.streetAddress)
				TextField("City", text: $currentOrder.order.city)
				TextField("Postal Code", text: $currentOrder.order.zip)
			}
			
			Section {
				NavigationLink {
					CheckoutView(order: currentOrder)
				} label: {
					Text("Check Out")
				}
				.disabled(!currentOrder.order.hasValidAddress)
			}
		}
		.navigationTitle("Delivery Details")
		.navigationBarTitleDisplayMode(.inline)
    }
	
	init(order currentOrder: OrderWrapper) {
		self.currentOrder = currentOrder
	}
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
		AddressView(order: OrderWrapper())
    }
}
