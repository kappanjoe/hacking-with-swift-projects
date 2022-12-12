//
//  ContentView.swift
//  WordScramble
//
//  Created by Joseph Van Alstyne on 12/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
	@State private var rootWord = ""
	@State private var newWord = ""
	@State private var score = 0
	
	@State private var errorTitle = ""
	@State private var errorMessage = ""
	@State private var showingError = false
	
	var body: some View {
		NavigationView {
			List {
				Section {
					TextField("Input a guess.", text: $newWord)
						.textInputAutocapitalization(.never)
						.autocorrectionDisabled()
				}

				Section {
					// Make sure to prevent duplicates when using .self as id
					ForEach(usedWords, id: \.self) { word in
						HStack {
							Image(systemName: "\(word.count).circle")
							Text(word)
						}
					}
				}
			}
			.navigationTitle(rootWord)
			.toolbar() {
				ToolbarItem(placement: .navigationBarTrailing) {
					Text("Score: \(score)")
						.font(.callout)
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Button("New Word", action: startGame)
				}
			}
			.onSubmit(addNewWord)
			.onAppear(perform: startGame)
			.alert(errorTitle, isPresented: $showingError) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(errorMessage)
			}
		}
    }
	
	func startGame() {
		// Find the URL of start.txt in app bundle
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			// Load contents into strong
			if let startWords = try? String(contentsOf: startWordsURL) {
				// Split into an array
				let allWords = startWords.components(separatedBy: "\n")
				// Pick a random work or default to "silkworm"
				rootWord = allWords.randomElement() ?? "silkworm"
				score = 0
				return
			}
		}
		
		// If nothing above worked, we have a problem
		fatalError("Could not load start.txt from bundle.")
	}
	
	func isOriginal(word: String) -> Bool {
		!usedWords.contains(word)
	}
	
	func isPossible(word: String) -> Bool {
		var tempWord = rootWord
		
		for letter in word {
			if let pos = tempWord.firstIndex(of: letter) {
				tempWord.remove(at: pos)
			} else {
				return false
			}
		}
		
		return true
	}
	
	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		
		return misspelledRange.location == NSNotFound
	}
	
	func wordError(title: String, message: String) {
		errorTitle = title
		errorMessage = message
		showingError = true
	}
	
	func addNewWord() {
		let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard answer.count >= 3 else {
			wordError(title: "Too Short", message: "Guesses must be 3 characters or longer!")
			return
		}
		
		guard isOriginal(word: answer) else {
			wordError(title: "Already Used", message: "Guesses will only be counted once!")
			return
		}
		
		guard isPossible(word: answer) else {
			wordError(title: "Not Possible", message: "Guesses may only use letters from '\(rootWord)'!")
			return
		}
		
		guard isReal(word: answer) else {
			wordError(title: "Not A Word", message: "Guesses must actually be a word!")
			return
		}
		
		
		withAnimation {
			usedWords.insert(answer, at: 0)
		}
		score += answer.count * ((usedWords.count / 10) + 1)
		newWord = ""
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
