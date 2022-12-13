//
//  CrewView.swift
//  Moonshot
//
//  Created by Joseph Van Alstyne on 12/13/22.
//

import SwiftUI

struct CrewView: View {
	let crew: [CrewMember]
	
	var body: some View {
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
}

struct CrewView_Previews: PreviewProvider {
	static let missions: [Mission] = Bundle.main.decode("missions.json")
	static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
	static let crew: [CrewMember] = missions[0].crew.map { member in
		if let astronaut = astronauts[member.name] {
			return CrewMember(role: member.role, astronaut: astronaut)
		} else {
			fatalError("Missing \(member.name)")
		}
	}
	
	static var previews: some View {
		CrewView(crew: crew)
			.preferredColorScheme(.dark)
    }
}
