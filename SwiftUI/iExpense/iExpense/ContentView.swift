//
//  ContentView.swift
//  iExpense
//
//  Created by Joseph Van Alstyne on 12/12/22.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
	var id = UUID()
	let name: String
	let type: String
	let amount: Double
}

class Expenses: ObservableObject {
	@Published var items = [ExpenseItem]() {
		didSet {
			if let encoded = try? JSONEncoder().encode(items) {
				UserDefaults.standard.set(encoded, forKey: "Items")
			}
		}
	}
	
	init() {
		if let savedItems = UserDefaults.standard.data(forKey: "Items") {
			if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
				items = decodedItems
				return
			}
		}
		
		items = []
	}
}

struct ContentView: View {
	@StateObject var expenses = Expenses()
	@State private var showAddView = false
	
	let currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "JPY")
	
	func removePersonalItems(at offsets: IndexSet) {
		let personalExpenses = expenses.items.filter({ element in
			return element.type == "Personal"
		})
		
		offsets.forEach({ index in
			expenses.items.removeAll(where: { item in
				return personalExpenses[index].id == item.id
			})
		})
	}
	
	func removeBusinessItems(at offsets: IndexSet) {
		let personalExpenses = expenses.items.filter({ element in
			return element.type == "Business"
		})
		
		offsets.forEach({ index in
			expenses.items.removeAll(where: { item in
				return personalExpenses[index].id == item.id
			})
		})
	}
	
	var body: some View {
		NavigationView {
			List {
				Section {
					ForEach(expenses.items.filter({ element in
						return element.type == "Personal"
					})) { item in
						HStack {
							Text(item.name)
								.font(.headline)
							Spacer()
							Text(item.amount, format: currencyFormat)
								.font(.title)
								.foregroundColor(item.amount > 10 ? (item.amount > 100 ? .indigo : .primary) : .gray)
						}
					}
					.onDelete(perform: removePersonalItems)
				} header: {
					Text("Personal")
				}
				
				Section {
					ForEach(expenses.items.filter({ element in
						return element.type == "Business"
					})) { item in
						HStack {
							Text(item.name)
								.font(.headline)
							Spacer()
							Text(item.amount, format: currencyFormat)
								.font(.title)
								.foregroundColor(item.amount > 10 ? (item.amount > 100 ? .indigo : .primary) : .gray)
						}
					}
					.onDelete(perform: removeBusinessItems)
				} header: {
					Text("Business")
				}
			}
			.navigationTitle("Expenses")
			.toolbar {
				Button {
					showAddView = true
				} label: {
					Image(systemName: "plus")
				}
			}
			.sheet(isPresented: $showAddView) {
				AddView(expenses: expenses)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
