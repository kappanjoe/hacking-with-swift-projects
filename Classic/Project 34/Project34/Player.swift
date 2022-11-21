//
//  Player.swift
//  Project34
//
//  Created by Joseph Van Alstyne on 11/18/22.
//

import UIKit
import GameKit

class Player: NSObject, GKGameModelPlayer {
    var chip: ChipColor
    var chipImg: String
    var name: String
    var playerId: Int
    
    static var allPlayers = [Player(chip: .red), Player(chip: .black)]
    
    init(chip: ChipColor) {
        self.chip = chip
        self.playerId = chip.rawValue
        
        if chip == .red {
            chipImg = "redchip.png"
            name = "Red"
        } else {
            chipImg = "blackchip.png"
            name = "Black"
        }
        
        super.init()
    }
    
    var opponent: Player {
        if chip == .red {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
}
