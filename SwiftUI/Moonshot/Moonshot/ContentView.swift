//
//  ContentView.swift
//  Moonshot
//
//  Created by Joseph Van Alstyne on 12/13/22.
//

import SwiftUI

struct ContentView: View {
	let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
	let missions: [Mission] = Bundle.main.decode("missions.json")
	
	@State private var gridModeActive = true
	
	var body: some View {
		NavigationView {
			Group {
				if gridModeActive {
					GridLayout(astronauts: astronauts, missions: missions)
				} else {
					ListLayout(astronauts: astronauts, missions: missions)
				}
			}
			.navigationTitle("Moonshot")
			.background(.darkBackground)
			.preferredColorScheme(.dark)
			.toolbar {
				Button {
					withAnimation {
						gridModeActive.toggle()
					}
				} label: {
					if gridModeActive {
						Image("rectangle.grid.1x2")
							.foregroundColor(.secondary)
					} else {
						Image("square.grid.2x2")
							.foregroundColor(.secondary)
					}
				}
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
