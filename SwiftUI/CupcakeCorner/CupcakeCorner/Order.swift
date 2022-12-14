//
//  Order.swift
//  CupcakeCorner
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

enum CodingKeys: CodingKey {
	case order
}

struct Order: Codable {
	static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
	
	var type = 0
	var quantity = 3

	var specialRequestEnabled = false {
		didSet {
			if !specialRequestEnabled {
				extraFrosting = false
				addSprinkles = false
			}
		}
	}
	var extraFrosting = false
	var addSprinkles = false
	
	var name = ""
	var streetAddress = ""
	var city = ""
	var zip = ""
	
	var hasValidAddress: Bool {
		let validName = try? name.contains(Regex("[a-z] [A-Z]"))
		let validAddress = try? streetAddress.contains(Regex("[0-9] [A-Z]"))
		let validCity = try? city.contains(Regex("\\A[a-zA-Z ]+$"))
		let validZip = try? zip.contains(Regex("\\A[0-9]{5}$"))
		return (validName ?? false) && (validAddress ?? false) && (validCity ?? false) && (validZip ?? false)
	}
	
	var cost: Double {
		// $2 per cake
		var cost = Double(quantity) * 2

		// complicated cakes cost more
		cost += (Double(type) / 2)

		// $1/cake for extra frosting
		if extraFrosting {
			cost += Double(quantity)
		}

		// $0.50/cake for sprinkles
		if addSprinkles {
			cost += Double(quantity) / 2
		}

		return cost
	}
}

class OrderWrapper: ObservableObject, Codable {
	@Published var order: Order
	
	init() {
		self.order = Order()
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(order, forKey: .order)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		order = try container.decode(Order.self, forKey: .order)
	}
}
