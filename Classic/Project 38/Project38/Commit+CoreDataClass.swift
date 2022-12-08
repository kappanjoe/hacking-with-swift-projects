//
//  Commit+CoreDataClass.swift
//  Project38
//
//  Created by Joseph Van Alstyne on 12/8/22.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
	override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
		print("Init called!")
	}
}
