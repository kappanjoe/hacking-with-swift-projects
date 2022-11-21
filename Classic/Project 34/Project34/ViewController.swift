//
//  ViewController.swift
//  Project34
//
//  Created by Joseph Van Alstyne on 11/17/22.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet var columnButtons: [UIButton]!
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, chipImg: board.currentPlayer.chipImg)
            continueGame()
        }
    }
    
    var placedChips = [[UIImageView]]()
    var board: Board!
    
    var strategist: GKMinmaxStrategist!
    var difficulty: Int!
    var useOpponentAI: Bool! {
        didSet {
            if useOpponentAI {
                let modeButton = UIBarButtonItem(title: "Play with 2 Players", style: .plain, target: self, action: #selector(swapMode))
                var difficultyButton = UIBarButtonItem(title: "Select Difficulty", style: .plain, target: self, action: #selector(selectDifficulty))
                DispatchQueue.main.async { [unowned self] in
                    self.navigationItem.rightBarButtonItem = modeButton
                    self.navigationItem.leftBarButtonItem = difficultyButton
                }
            } else {
                let modeButton = UIBarButtonItem(title: "Play with AI Opponent", style: .plain, target: self, action: #selector(swapMode))
                DispatchQueue.main.async { [unowned self] in
                    self.navigationItem.rightBarButtonItem = modeButton
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIImageView]())
        }
        
        difficulty = 3
        useOpponentAI = false
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = difficulty
        strategist.randomSource = nil
        
        resetBoard()
    }
    
    @objc func swapMode() {
        useOpponentAI.toggle()
    }
    
    @objc func selectDifficulty() {
        let ac = UIAlertController(title: "Select Difficulty", message: "Current game will be reset.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Easy", style: .default) { [unowned self] action in
            self.difficulty = 1
            resetBoard()
        })
        ac.addAction(UIAlertAction(title: "Medium", style: .default) { [unowned self] action in
            self.difficulty = 3
            resetBoard()
        })
        ac.addAction(UIAlertAction(title: "Hard", style: .default) { [unowned self] action in
            self.difficulty = 7
            resetBoard()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func resetBoard() {
        board = Board()
        strategist.gameModel = board
        
        updateUI()
        
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    func addChip(inColumn column: Int, row: Int, chipImg: String) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if (placedChips[column].count < row + 1) {
            let newChip = UIImageView(image: UIImage(named: chipImg))
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIImageView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChips[column].append(newChip)
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        
        let xOffset = button.frame.midX + 20 // Distance from safe area
        var yOffset = button.frame.maxY - (size / 2) + 10 // Distance from safe area
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }

    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.chip == .black && useOpponentAI {
            startAIMove()
        }
    }
    
    func continueGame() {
        var gameOverTitle: String? = nil
        
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetBoard()
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
            
            return
        }
        
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
    
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    func makeAIMove(in column: Int) {
        columnButtons.forEach { $0.isEnabled = true }
        var difficultyButton = UIBarButtonItem(title: "Select Difficulty", style: .plain, target: self, action: #selector(selectDifficulty))
        navigationItem.leftBarButtonItem = difficultyButton
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, chipImg: board.currentPlayer.chipImg)
            
            continueGame()
        }
    }
    
    func startAIMove() {
        columnButtons.forEach { $0.isEnabled = false }
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            // Delay to prevent confusing user if AI responds too quickly
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }
}

