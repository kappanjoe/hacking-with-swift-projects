//
//  AddBookView.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/15/22.
//

import SwiftUI

struct AddBookView: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	
	@State private var title = ""
	@State private var author = ""
	@State private var rating = 0
	@State private var genre = ""
	@State private var review = ""
	
	let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
	
	func isValidBook() -> Bool {
		let validTitle = title.count > 0
		let validAuthor = author.count > 0
		let validRating = rating > 0
		let validGenre = genre.count > 0
		let validReview = review.count > 0
		return !(validTitle && validAuthor && validRating && validGenre && validReview)
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Book Title", text: $title)
					TextField("Book Author", text: $author)
					
					Picker("Genre", selection: $genre) {
						ForEach(genres, id: \.self) {
							Text($0)
						}
					}
				}
				
				Section {
					TextEditor(text: $review)
					RatingView(rating: $rating)
				} header: {
					Text("Review")
				}
				
				Section {
					Button("Save") {
						let newBook = Book(context: moc)
						newBook.id = UUID()
						newBook.title = title
						newBook.author = author
						newBook.rating = Int16(rating)
						newBook.genre = genre
						newBook.review = review
						newBook.reviewDate = Date.now

						try? moc.save()
						dismiss()
					}
					.disabled(isValidBook())
				}
			}
			.navigationTitle("Add Book")
		}
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
