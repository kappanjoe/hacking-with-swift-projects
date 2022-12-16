//
//  DataController.swift
//  CoreDataTechniques
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
	let container = NSPersistentContainer(name: "CoreDataTechniques")
	
	init() {
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
				return
			}
			
			// Overwrites storage with changes from duplicate object attempting to be saved
			self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
		}
	}
}
