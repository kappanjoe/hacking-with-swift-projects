//
//  ContentView.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: [
		SortDescriptor(\.title),
		SortDescriptor(\.author)
	]) var books: FetchedResults<Book>
	
	@State private var showAddBookView = false
	
	func deleteBooks(at offsets: IndexSet) {
		for offset in offsets {
			let book = books[offset]
			moc.delete(book)
		}
		
		try? moc.save()
	}
	
	var body: some View {
		NavigationView {
			List {
				ForEach(books) { book in
					NavigationLink {
						DetailView(book: book)
					} label: {
						HStack {
							EmojiRatingView(rating: book.rating)
								.font(.largeTitle)
							
							VStack(alignment: .leading) {
								Text(book.title ?? "Unknown Title")
									.font(.headline)
								Text(book.author ?? "Unknown Author")
									.foregroundColor(.secondary)
							}
						}
					}
				}
				.onDelete(perform: deleteBooks)
			}
				.navigationTitle("Bookworm")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						EditButton()
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							showAddBookView = true
						} label: {
							Label("Add Book", systemImage: "plus")
						}
					}
				}
				.sheet(isPresented: $showAddBookView) {
					AddBookView()
				}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
        ContentView()
    }
}
