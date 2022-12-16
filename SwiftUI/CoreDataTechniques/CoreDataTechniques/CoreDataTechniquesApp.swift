//
//  CoreDataTechniquesApp.swift
//  CoreDataTechniques
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import SwiftUI

@main
struct CoreDataTechniquesApp: App {
    @StateObject private var dataController = DataController()
	
	var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
