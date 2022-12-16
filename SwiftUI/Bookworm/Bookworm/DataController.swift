//
//  DataController.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
	let container = NSPersistentContainer(name: "Bookworm")
	
	init() {
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
			}
		}
	}
}
