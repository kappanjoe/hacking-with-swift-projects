//
//  RatingView.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import SwiftUI

struct RatingView: View {
	@Binding var rating: Int
	var maxRating = 5
	
	var label = ""
	
	var offColor = Color.secondary
	var onColor = Color.accentColor
	
	var offImage: Image?
	var onImage = Image(systemName: "star.fill")
	
	func image(for number: Int) -> Image {
		if number > rating {
			return offImage ?? onImage
		} else {
			return onImage
		}
	}
	
	var body: some View {
		HStack {
			if !label.isEmpty {
				Text(label)
			}
			
			ForEach(1..<maxRating + 1, id: \.self) { number in
				image(for: number)
					.foregroundColor(number > rating ? offColor : onColor)
					.onTapGesture {
						rating = number
					}
			}
		}
	}
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
		RatingView(rating: .constant(4))
    }
}
