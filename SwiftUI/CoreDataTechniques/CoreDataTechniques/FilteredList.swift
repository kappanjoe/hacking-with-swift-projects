//
//  FilteredListView.swift
//  CoreDataTechniques
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import CoreData
import SwiftUI

enum Predicate {
	case beginsWith
	case contains
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
	@FetchRequest var fetchRequest: FetchedResults<T>
	
	let content: (T) -> Content
	
	var body: some View {
		List(fetchRequest, id: \.self) { obj in
			self.content(obj)
		}
    }
	
	init(key: String, filter: String, predicate: Predicate, sortDescriptors: SortDescriptor<T>, @ViewBuilder content: @escaping (T) -> Content) {
		// Underscore modifier tells Swift to generate a new instance of the FetchRequest from scratch instead of updating any existing instance
		let predicateString: String
		switch predicate {
		case .beginsWith:
			predicateString = "BEGINSWITH"
		default:
			predicateString = "CONTAINS"
		}
		
		_fetchRequest = FetchRequest<T>(sortDescriptors: [sortDescriptors], predicate: NSPredicate(format: "%K \(predicateString) %@", key, filter))
		self.content = content
	}
}
