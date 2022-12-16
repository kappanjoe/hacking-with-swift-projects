//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
	
	var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
