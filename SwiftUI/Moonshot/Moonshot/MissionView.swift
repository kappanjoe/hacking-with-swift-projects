//
//  MissionView.swift
//  Moonshot
//
//  Created by Joseph Van Alstyne on 12/13/22.
//

import SwiftUI

struct MissionView: View {
	struct CrewMember {
		let role: String
		let astronaut: Astronaut
	}
	
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
					
					ScrollView(.horizontal, showsIndicators: false) {
						HStack {
							ForEach(crew, id:\.role) { crewMember in
								NavigationLink {
									AstronautView(astronaut: crewMember.astronaut)
								} label: {
									HStack {
										Image(crewMember.astronaut.id)
											.resizable()
											.frame(width: 104, height: 72)
											.clipShape(Capsule())
											.overlay(
												Capsule()
													.strokeBorder(.secondary, lineWidth: 2)
											)
										
										VStack(alignment: .leading) {
											Text(crewMember.astronaut.name)
												.foregroundColor(.white)
												.font(.headline)
											Text(crewMember.role)
												.foregroundColor(.secondary)
										}
									}
									.padding(.horizontal)
								}
							}
						}
					}
					.padding(.bottom)
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
