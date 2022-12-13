//
//  ListLayout.swift
//  Moonshot
//
//  Created by Joseph Van Alstyne on 12/13/22.
//

import SwiftUI

struct ListLayout: View {
	let astronauts: [String: Astronaut]
	let missions: [Mission]
	
	var body: some View {
		List {
			ForEach(missions) { mission in
				NavigationLink {
					MissionView(mission: mission, astronauts: astronauts)
				} label: {
					HStack {
						Image(mission.image)
							.resizable()
							.scaledToFit()
							.frame(width: 80, height: 80)
							.padding()
						
						VStack {
							Text(mission.displayName)
								.font(.title2)
								.foregroundColor(.white)
								.padding(.bottom, 2)
							Text(mission.formattedLaunchDate)
								.font(.subheadline)
								.foregroundColor(.white.opacity(0.5))
						}
						.padding(.vertical)
						.frame(maxWidth: .infinity)
					}
					.background(.lightBackground)
					.clipShape(RoundedRectangle(cornerRadius: 10))
				}
			}
			.listRowBackground(Color.darkBackground)
		}
		.listStyle(.plain)
		.background(.darkBackground)
	}
}

struct ListLayout_Previews: PreviewProvider {
	static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
	static let missions: [Mission] = Bundle.main.decode("missions.json")
	
	static var previews: some View {
        ListLayout(astronauts: astronauts, missions: missions)
			.preferredColorScheme(.dark)
    }
}
