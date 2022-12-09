//
//  PlayData.swift
//  Project39
//
//  Created by Joseph Van Alstyne on 12/9/22.
//

import Foundation

class PlayData {
	init () {
		if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
			if let plays = try? String(contentsOfFile: path) {
				allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
			}
		}
		allWords = allWords.filter { $0 != "" }
		wordCounts = NSCountedSet(array: allWords)
		allWords = wordCounts.allObjects.sorted { wordCounts.count(for: $0) > wordCounts.count(for: $1) } as! [String]
		
		applyUserFilter("swift")
		// filteredWords = allWords
	}
	
	func applyUserFilter(_ input: String) {
		if let userNumber = Int(input) {
			applyFilter { self.wordCounts.count(for: $0) >= userNumber }
		} else {
			applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
		}
	}
	
	func applyFilter(_ filter: (String) -> Bool) {
		filteredWords = allWords.filter(filter)
	}
	
	var allWords = [String]()
	
	var wordCounts: NSCountedSet!
	
	private(set) var filteredWords = [String]()
}
