//
//  ViewController.swift
//  ConnectFour
//
//  Created by Arman Vaziri on 12/13/19.
//  Copyright © 2019 ArmanVaziri. All rights reserved.
//

/*
TO DO:
 1. Fix bug(s):
    - User tap on full column disables user tap on board permanently
    - Autolayout
 2. AI can randomly select same full row infinitely
 3. Make the AI a little bit smarter
 4. Create Player.swift which is a struct
 */

import UIKit

struct Constants {
    static let tokenImageTag: Int = 77
    static let numRows: Int = 6
    static let numColumns: Int = 7
}

class ViewController: UIViewController {
    
    var board: Board!
    
    var userTouchEnabled: Bool = true
    
    @IBOutlet weak var numberMovesLabel: UILabel!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var boardStack: UIStackView!
    @IBOutlet var boardColumnViews: [UIView]!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        board = Board(columns: Constants.numColumns, rows: Constants.numRows)
        setupUI()
    }
    
    func setupUI() {
        restartButton.layer.cornerRadius = 20
    }
    
    // User tap
    @IBAction func tapOnColumn(_ sender: UIButton) {
    
        if userTouchEnabled && board.currPlayer == 1 {
            
            userTouchEnabled = false
            
            move(column: sender.tag)
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        restart()
    }
    
    /* Update 2D array representing the board, then display the token and update the current player. */
    func move(column: Int) {
        
        let row: Int = board.findRow(column: column)
        
        // Checks if move is valid
        if row != -1 {

            showToken(column: column, row: row, currentPlayer: board.currPlayer)
            
            if board.isWin(player: board.currPlayer, column: column, row: row) {
                
                // Adds delay to prevent animation interruption
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    
                    self.winAlert(winner: self.board.winner)
                }
                return
            }
            
            updateCurrentPlayer()
            
            // AI move call here
            if board?.currPlayer == 2 {
                
                // Add delay to avoid overly quick computer turns 
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    
                    self.aiMove()
                    
                    self.userTouchEnabled = true
                }
                
            }
        }
    }
    
    // AI Potentially never picks empty column, write method that disincludes 
    func aiMove() {
        
        var randomColumn: Int = Int.random(in: 0..<board.columns)
        
        var validColumn: Bool = board.validateCol(column: randomColumn)
        
        while validColumn == false {
            
            randomColumn = Int.random(in: 0..<board.columns)
            
            validColumn = board.validateCol(column: randomColumn)
            
        }
        
        move(column: randomColumn)
    }
    
    // update UI to display appropriate token
    func showToken(column: Int, row: Int, currentPlayer: Int) {
        
        let columnView = boardColumnViews[column]
           
        let frameWidth = columnView.frame.width - 2
        let frameHeight = columnView.frame.height / 6
        
        let tokenSize = max(frameHeight, frameWidth)
        let tokenFrame = CGRect(x: 0, y: 0, width: tokenSize - 5, height: tokenSize - 5)
        let tokenView = UIImageView()
        
        if board.currPlayer == 1 {
            tokenView.image = UIImage(named: "RedToken")
        } else {
            tokenView.image = UIImage(named: "YellowToken")
        }
        
        tokenView.frame = tokenFrame
        tokenView.contentMode = .scaleAspectFit
        tokenView.tag = Constants.tokenImageTag
            
        let x = columnView.frame.midX + boardStack.frame.minX
        let y = (columnView.frame.maxY - tokenSize / 2 + boardStack.frame.minY) - (tokenSize * CGFloat(row))
    
        tokenView.center = CGPoint(x: x, y: y)
        tokenView.transform = CGAffineTransform(translationX: 0, y: -500)
        view.addSubview(tokenView)
        
        // Token animation
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            tokenView.transform = CGAffineTransform.identity })
    }
    
    // Update UI and code to the appropriate current player
    func updateCurrentPlayer() {
        
        if board.currPlayer == 1 {
            
           self.tokenImage.image = UIImage(named: "YellowToken")
            
           self.turnLabel.text = "Computer's Turn"
            
           self.numberMovesLabel.text = "Number of moves: \(self.board.numMoves)"
            
        } else if board?.currPlayer == 2 {
            
            self.tokenImage.image = UIImage(named: "RedToken")
            
            self.turnLabel.text = "Your Turn"
            
            self.numberMovesLabel.text = "Number of moves: \(self.board.numMoves)"

        }
        board.move()
    }
    
    // Show alert for win game state (1 means human, 2 means AI)
    func winAlert(winner: Int) {
        
        var title = ""
        var message = ""
        
        // Human wins
        if winner == 1 {
            
            title = "Great job!"
            
            message = "You won! Want to play again? :)"
        }
        // AI wins
        else if winner == 2 {
            
            title = "Oh no!"
            
            message = "You lost! Try again? :) "
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Alert controller action restarts game
        let playAgain = UIAlertAction(title: "Play Again", style: .default) { (UIAlertAction) in self.restart()}
        
        alert.addAction(playAgain)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Starts a new game
    func restart() {
        
        // Instantiate new board/game settings
        board = Board(columns: Constants.numColumns, rows: Constants.numRows)
        
        self.userTouchEnabled = true
        
        self.numberMovesLabel.text = "Number of moves: 0"
        
        self.tokenImage.image = UIImage(named: "RedToken")
        
        self.turnLabel.text = "Your turn"
        
        // clear token images from view
        for subviews in self.view.subviews {
            
            if let viewWithTag = self.view.viewWithTag(Constants.tokenImageTag) {
                
                viewWithTag.removeFromSuperview()
            }
        }
        
    }
    

}

