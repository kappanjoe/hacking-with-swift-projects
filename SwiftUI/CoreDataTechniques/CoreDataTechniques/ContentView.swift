//
//  ContentView.swift
//  CoreDataTechniques
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import CoreData
import SwiftUI

// If something conforms to Hashable, Core Data will assign a unique Object ID among other properties
struct Student: Hashable {
	let name: String
}

struct ContentView: View {
	@Environment(\.managedObjectContext) var moc

//	@FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
//	@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe IN %@", ["Aliens", "Firefly", "Star Trek"])) var ships: FetchedResults<Ship>
//	@State private var lastNameFilter = "A"
//
//	let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]
	
	@FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
	
    var body: some View {
		// \.self will point to the object hash; with unique IDs, every hash will also be unique
		VStack{
//			List(students, id: \.self) { student in
//				Text(student.name)
//			}
//
//			List(wizards, id: \.self) { wizard in
//				Text(wizard.name ?? "Unknown")
//			}
//
//			List(ships, id: \.self) { ship in
//				Text(ship.name ?? "Unknown ship")
//			}
//
//			Button("Add ships") {
//				let ship1 = Ship(context: moc)
//				ship1.name = "Enterprise"
//				ship1.universe = "Star Trek"
//
//				let ship2 = Ship(context: moc)
//				ship2.name = "Defiant"
//				ship2.universe = "Star Trek"
//
//				let ship3 = Ship(context: moc)
//				ship3.name = "Millennium Falcon"
//				ship3.universe = "Star Wars"
//
//				let ship4 = Ship(context: moc)
//				ship4.name = "Executor"
//				ship4.universe = "Star Wars"
//
//				try? moc.save()
//			}
			
//			FilteredList(key: "lastName", filter: lastNameFilter) { (obj: Singer) in
//				Text("\(obj.wrappedFirstName) \(obj.wrappedLastName)")
//			}
			
//			Button("Generate Examples") {
//				let taylor = Singer(context: moc)
//				taylor.firstName = "Taylor"
//				taylor.lastName = "Swift"
//
//				let ed = Singer(context: moc)
//				ed.firstName = "Ed"
//				ed.lastName = "Sheeran"
//
//				let adele = Singer(context: moc)
//				adele.firstName = "Adele"
//				adele.lastName = "Adkins"
//
//				try? moc.save()
//			}
//
//			Button("Show A") {
//				lastNameFilter = "A"
//			}
//
//			Button("Show S") {
//				lastNameFilter = "S"
//			}
			
			List {
				ForEach(countries, id:\.self) { country in
					Section(country.wrappedFullName) {
						ForEach(country.candyArray, id: \.self) { candy in
							Text(candy.wrappedName)
						}
					}
				}
			}
			
			FilteredList(key: "name", filter: "K", predicate: .beginsWith, sortDescriptors: SortDescriptor(\.name)) { (obj: Candy) in
				Text("\(obj.wrappedName)")
			}
			
			Button("Add") {
				let candy1 = Candy(context: moc)
				candy1.name = "Mars"
				candy1.origin = Country(context: moc)
				candy1.origin?.shortName = "UK"
				candy1.origin?.fullName = "United Kingdom"

				let candy2 = Candy(context: moc)
				candy2.name = "KitKat"
				candy2.origin = Country(context: moc)
				candy2.origin?.shortName = "UK"
				candy2.origin?.fullName = "United Kingdom"

				let candy3 = Candy(context: moc)
				candy3.name = "Twix"
				candy3.origin = Country(context: moc)
				candy3.origin?.shortName = "UK"
				candy3.origin?.fullName = "United Kingdom"

				let candy4 = Candy(context: moc)
				candy4.name = "Toblerone"
				candy4.origin = Country(context: moc)
				candy4.origin?.shortName = "CH"
				candy4.origin?.fullName = "Switzerland"

				try? moc.save()
			}
			.padding()
			
			Button("Save") {
				do {
					try moc.save()
				} catch {
					print(error.localizedDescription)
				}
			}
			.padding()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
