//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

struct AddressView: View {
	@ObservedObject var order: Order
	
	var body: some View {
		Form {
			Section {
				TextField("Name", text: $order.name)
				TextField("Mailing Address", text: $order.streetAddress)
				TextField("City", text: $order.city)
				TextField("Postal Code", text: $order.zip)
			}
			
			Section {
				NavigationLink {
					CheckoutView(order: order)
				} label: {
					Text("Check Out")
				}
				.disabled(!order.hasValidAddress)
			}
		}
		.navigationTitle("Delivery Details")
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
		AddressView(order: Order())
    }
}
