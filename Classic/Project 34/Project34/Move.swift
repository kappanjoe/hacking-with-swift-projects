//
//  Move.swift
//  Project34
//
//  Created by Joseph Van Alstyne on 11/18/22.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
