//
//  AuthorViewController.swift
//  Project38
//
//  Created by Joseph Van Alstyne on 12/9/22.
//

import UIKit
import CoreData

class AuthorViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var authorItem: Author?
	
	var container: NSPersistentContainer!
	
	var fetchedResultsController: NSFetchedResultsController<Commit>!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let author = authorItem {
			title = "Commits by \(author.name)"
			
			container = NSPersistentContainer(name: "Project38")
			container.loadPersistentStores { storeDescription, error in
				self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
				
				if let error = error {
					print("Unresolved error \(error)")
				}
			}
			
			loadSavedData()
		}
    }
	
	func loadSavedData() {
		if fetchedResultsController == nil {
			let request = Commit.createFetchRequest()
			let sort = NSSortDescriptor(key: "date", ascending: false)
			request.sortDescriptors = [sort]
			request.fetchBatchSize = 20
			
			fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
			fetchedResultsController.delegate = self
		}
		
		fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "author.name == %@", authorItem!.name)
		
		do {
			try fetchedResultsController.performFetch()
			tableView.reloadData()
		} catch {
			print("Fetch failed.")
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("This many cells: \(fetchedResultsController.fetchedObjects!.count)")
		return fetchedResultsController.fetchedObjects!.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Author Commit", for: indexPath)
		
		let commit = fetchedResultsController.object(at: indexPath)
		cell.textLabel!.text = commit.message
		cell.detailTextLabel!.text = commit.date.description
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		return
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
