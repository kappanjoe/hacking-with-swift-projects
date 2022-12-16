//
//  DetailView.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import CoreData
import SwiftUI

struct DetailView: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	
	@State private var showDeleteAlert = false
	
	let book: Book
	
	func deleteBook() {
		moc.delete(book)
		
		// uncomment this line if you want to make the deletion permanent
		// try? moc.save()
		dismiss()
	}
	
	var body: some View {
		ScrollView {
			ZStack(alignment: .bottomTrailing) {
				Image(book.genre ?? "Fantasy")
					.resizable()
					.scaledToFit()
				
				Text(book.genre?.uppercased() ?? "FANTASY")
					.font(.caption)
					.fontWeight(.black)
					.padding(8)
					.foregroundColor(.white)
					.background(.black.opacity(0.75))
					.clipShape(Capsule())
					.offset(x: -5, y: -5)
			}
			
			Text(book.author ?? "Unknown Author")
				.font(.title2)
				.foregroundColor(.secondary)
			
			Text(book.review ?? "No Review")
				.padding()
			
			RatingView(rating: .constant(Int(book.rating)))
				.font(.largeTitle)
			
			Text("Date Reviewed: \(book.reviewDate?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")")
				.font(.caption)
				.padding()
		}
		.navigationTitle(book.title ?? "Unknown Book")
		.navigationBarTitleDisplayMode(.inline)
		.alert("Delete book", isPresented: $showDeleteAlert) {
			Button("Delete", role: .destructive, action: deleteBook)
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("Are you sure?")
		}
		.toolbar {
			Button {
				showDeleteAlert = true
			} label: {
				Label("Delete this book", systemImage: "trash")
			}
		}
    }
}

struct DetailView_Previews: PreviewProvider {
	static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

	static var previews: some View {
		let book = Book(context: moc)
		book.title = "Preview book"
		book.author = "Preview author"
		book.genre = "Fantasy"
		book.rating = 4
		book.review = "This was a really good book. I enjoyed it."
		book.reviewDate = Date.now

		return NavigationView {
			DetailView(book: book)
		}
    }
}
