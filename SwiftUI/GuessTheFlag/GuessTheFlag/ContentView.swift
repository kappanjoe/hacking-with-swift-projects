//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Joseph Van Alstyne on 12/10/22.
//

import SwiftUI

struct ContentView: View {
	@State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
		.shuffled()
	@State private var correctAnswer = Int.random(in: 0...2)
	
	@State private var showingScore = false
	@State private var scoreTitle = ""
	@State private var scoreMessage = ""
	@State private var score = 0
	
	@State private var gameOver = false
	
	var body: some View {
		ZStack {
			RadialGradient(stops: [
				.init(color: .indigo, location: 0.4),
				.init(color: Color(red: 0.2, green: 0.15, blue: 0.2), location: 0.7),
			], center: .top, startRadius: 100, endRadius: 800)
			.ignoresSafeArea()
			VStack {
				Spacer()
				Text("Guess The Flag")
					.foregroundColor(.white)
					.font(.title.bold())
				VStack(spacing: 30) {
					VStack {
						Text("Which flag represents")
							.foregroundColor(.secondary)
							.font(.subheadline.weight(.semibold))
						Text("\(countries[correctAnswer])?")
							.font(.largeTitle.weight(.bold))
					}
					ForEach(0..<3) { number in
						Button {
							flagTapped(number)
						} label: {
							FlagImage(country: countries[number])
						}
					}
				}
				.frame(maxWidth: .infinity)
				.padding(.vertical, 40)
				.padding(.horizontal, 60)
				.background(.regularMaterial)
				.clipShape(RoundedRectangle(cornerRadius: 26))
				Spacer()
				Spacer()
				Text("Score: \(score)")
					.foregroundColor(.white)
					.font(.title.bold())
				Spacer()
			}
			.padding()
		}
		.alert(scoreTitle, isPresented: $showingScore) {
			Button("Continue", action: askQuestion)
		} message: {
			Text(scoreMessage)
		}
		.alert("You Win!", isPresented: $gameOver) {
			Button("New Game", action: resetGame)
		}
	}
	
	func flagTapped(_ number: Int) {
		if number == correctAnswer {
			scoreTitle = "Correct"
			score += 1
			scoreMessage = "Your score is \(score)!"
		} else {
			scoreTitle = "Incorrect"
			score -= 1
			scoreMessage = "You tapped on \(countries[number]).\nYour score is now \(score)."
		}

		showingScore = true
	}
	
	func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
		if score == 8 {
			gameOver = true
		}
	}
	
	func resetGame() {
		score = 0
	}
}

struct FlagImage: View {
	var country: String
	
	var body: some View {
		Image(country)
			.renderingMode(.original)
			.clipShape(RoundedRectangle(cornerRadius: 18))
			.shadow(radius: 8)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
