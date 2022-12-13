//
//  MissionView.swift
//  Moonshot
//
//  Created by Joseph Van Alstyne on 12/13/22.
//

import SwiftUI

struct CrewMember {
	let role: String
	let astronaut: Astronaut
}

struct MissionView: View {
	
	let mission: Mission
	let crew: [CrewMember]
	
	init(mission: Mission, astronauts: [String: Astronaut]) {
		self.mission = mission
		
		self.crew = mission.crew.map { member in
			if let astronaut = astronauts[member.name] {
				return CrewMember(role: member.role, astronaut: astronaut)
			} else {
				fatalError("Missing \(member.name)")
			}
		}
	}
	
	var body: some View {
		GeometryReader { geo in
			ScrollView {
				VStack {
					Image(mission.image)
						.resizable()
						.scaledToFit()
						.frame(maxWidth: geo.size.width * 0.6)
						.padding(.top)
					
					Text(mission.formattedLaunchDate)
						.font(.headline)
						.foregroundColor(.white.opacity(0.5))
						.padding(.vertical, 5)
					
					VStack(alignment: .leading) {
						
						Rectangle()
							.frame(height: 2)
							.foregroundColor(.lightBackground)
							.padding(.vertical)
						
						Text("Mission Highlights")
							.font(.title.bold())
							.padding(.vertical, 5)
						
						Text(mission.description)
						
						Rectangle()
							.frame(height: 2)
							.foregroundColor(.lightBackground)
							.padding(.vertical)
						
						Text("Mission Crew")
							.font(.title.bold())
							.padding(.bottom)
					}
					.padding(.horizontal)
					
					CrewView(crew: crew)
				}
				.padding(.bottom)
			}
		}
		.navigationTitle(mission.displayName)
		.navigationBarTitleDisplayMode(.inline)
		.background(.darkBackground)
    }
}

struct MissionView_Previews: PreviewProvider {
	static let missions: [Mission] = Bundle.main.decode("missions.json")
	static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

	static var previews: some View {
		MissionView(mission: missions[0], astronauts: astronauts)
			.preferredColorScheme(.dark)
	}
}
