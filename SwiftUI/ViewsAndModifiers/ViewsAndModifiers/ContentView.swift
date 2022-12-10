//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Joseph Van Alstyne on 12/10/22.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack(spacing: 10) {
			CapsuleText(text: "First")
				.foregroundColor(.white)
			CapsuleText(text: "Second")
				.foregroundColor(.yellow)
			CapsuleText(text: "Third")
				.foregroundColor(.gray)
			Text("Goodbye Mars")
				.modifier(Title())
			Text("Hello World")
				.titleStyle()
			Color.blue
				.frame(width: 300, height: 200)
				.watermarked(with: "Hacking with Swift")
			GridStack(rows: 4, columns: 4) { row, col in
						Text("R\(row) C\(col)")
					}
			GridStack(rows: 4, columns: 4) { row, col in
				Image(systemName: "\(row * 4 + col).circle")
				Text("R\(row) C\(col)")
			}
		}
	}
}

struct CapsuleText: View {
	var text: String

	var body: some View {
		Text(text)
			.font(.largeTitle)
			.padding()
			.foregroundColor(.white)
			.background(.blue)
			.clipShape(Capsule())
	}
}

struct GridStack<Content: View>: View {
	let rows: Int
	let columns: Int
	@ViewBuilder let content: (Int, Int) -> Content

	var body: some View {
		VStack {
				ForEach(0..<rows, id: \.self) { row in
					// id required when value in range may change
					HStack {
						ForEach(0..<columns, id: \.self) { column in
							content(row, column)
						}
					}
				}
			}
	}
}

struct Title: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle)
			.foregroundColor(.white)
			.padding()
			.background(.blue)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}

struct Watermark: ViewModifier {
	var text: String

	func body(content: Content) -> some View {
		ZStack(alignment: .bottomTrailing) {
			content
			Text(text)
				.font(.caption)
				.foregroundColor(.white)
				.padding(5)
				.background(.black)
		}
	}
}

extension View {
	// Custom ViewModifiers can store properties
	// Extensions (like below) cannot
	func titleStyle() -> some View {
		modifier(Title())
	}
	
	func watermarked(with text: String) -> some View {
			modifier(Watermark(text: text))
		}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
