//
//  Board.swift
//  Project34
//
//  Created by Joseph Van Alstyne on 11/17/22.
//

import UIKit
import GameplayKit

enum ChipColor: Int {
    case none = 0
    case red
    case black
    // Swift will auto-increment for each case
}

class Board: NSObject, GKGameModel {
    static var width = 7
    static var height = 6
    var currentPlayer: Player
    
    var slots = [ChipColor]()
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    override init() {
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }
        
        currentPlayer = Player.allPlayers[0]
        
        super.init()
    }
    
    func chip(inColumn column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }
    
    func set(chip: ChipColor, in column: Int, row: Int) {
        slots[row + column * Board.height] = chip
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(chip: ChipColor, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }
    
    func isFull() -> Bool {
        for column in 0 ..< Board.width {
            if canMove(in: column) {
                return false
            }
        }
        
        return true
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let chip = (player as! Player).chip
        
        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if squaresMatch(initialChip: chip, col: col, row: row, moveX: 1, moveY: 0) {
                    return true
                } else if squaresMatch(initialChip: chip, col: col, row: row, moveX: 0, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, col: col, row: row, moveX: 1, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, col: col, row: row, moveX: 1, moveY: -1) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func squaresMatch(initialChip: ChipColor, col: Int, row: Int, moveX: Int, moveY: Int) -> Bool {
        // Bail if exceeds bounds of board
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= Board.height { return false }
        if col + (moveX * 3) < 0 { return false }
        if col + (moveX * 3) >= Board.width { return false }
        
        // Now check every spot in line
        if chip(inColumn: col, row: row) != initialChip { return false }
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
        
        // All checks passed
        return true
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        // Optionally downcast GKGameModelPlayer into Player
        if let playerObject = player as? Player {
            // If winner exists, return nil to signal no further moves available
            if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
                return nil
            }
            
            // Otherwise, create a new array holding Move objects
            var moves = [Move]()
            
            // Loop through columns and check if another move is possible
            for column in 0 ..< Board.width {
                if canMove(in: column) {
                    // If possible, create a new Move object for the column and add to array
                    moves.append(Move(column: column))
                }
            }
            
            // Return array to tell AI all possible moves
            return moves
        }
        
        return nil
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            add(chip: currentPlayer.chip, in: move.column)
            currentPlayer = currentPlayer.opponent
        }
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWin(for: playerObject) {
                return 1000
            } else if isWin(for: playerObject.opponent) {
                return -1000
            }
        }
        
        return 0
    }
}
