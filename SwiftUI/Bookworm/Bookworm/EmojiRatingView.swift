//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Joseph Van Alstyne on 12/16/22.
//

import SwiftUI

struct EmojiRatingView: View {
	let rating: Int16
	
	var body: some View {
		switch rating {
		case 1:
			Text("😪")
		case 2:
			Text("😕")
		case 3:
			Text("🙃")
		case 4:
			Text("😲")
		default:
			Text("😍")
		}
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
		EmojiRatingView(rating: 3)
    }
}
