//
//  Movie+CoreDataProperties.swift
//  CoreDataTechniques
//
//  Created by Joseph Van Alstyne on 12/16/22.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16
	
	public var wrappedTitle: String {
		title ?? "Unknown Title"
	}

}

extension Movie : Identifiable {

}
