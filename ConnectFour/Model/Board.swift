//
//  Board.swift
//  ConnectFour
//
//  Created by Arman Vaziri on 12/13/19.
//  Copyright © 2019 ArmanVaziri. All rights reserved.
//

import Foundation

class Board {
    
    // Dimensions of the board
    var columns: Int!
    var rows: Int!
    
    // Game history
    var numMoves: Int = 0
    
    // The 2D array that represents the board grid and each position
    var grid = [[Int]]()
    
    // The current player, either 1 or 2, human or ai, respectively
    var currPlayer: Int = 0
    
    var winner: Int = 0
    
    // Instantiate a new board and game state
    init(columns: Int, rows: Int) {
        
        self.columns = columns
        self.rows = rows
        currPlayer = 1
        numMoves = 0
        
        for _ in 0..<columns {
            var temp = [Int]()
            for _ in 0..<rows {
                temp.append(0)
            }
            grid.append(temp)
        }
    }
    
    // Makes appropriate changes to the game state
    func move() {
        if currPlayer == 1 {
            currPlayer = 2
            numMoves += 1
        }
        else {
            currPlayer = 1
        }
    }
    
    // Returns the empty row in the given column
    func findRow(column: Int) -> Int {
        var returnRow: Int = -1
        // Updates the grid array if column is not full, finds row within column to place token
        for row in 0..<rows {
            if grid[column][row] == 0 {
                grid[column][row] = currPlayer
                returnRow = row
                break
            }
        }
        return returnRow
    }
    
    // Validates that the column is not full
    func validateCol(column: Int) -> Bool {
        if grid[column][5] == 0 { return true }
        else { return false }
    }
   
    
    // Checks if the player has won
    func isWin(player: Int, column: Int, row: Int) -> Bool {
        if verticalWin(player: player, column: column, row: row) { return true }
        else if horizontalWin(player: player, column: column, row: row) { return true }
        else if diagonalNegativeWin(player: player, column: column, row: row) { return true }
        else if diagonalPositiveWin(player: player, column: column, row: row) { return true }
        else { return false }
    }
    
    func verticalWin(player: Int, column: Int, row: Int) -> Bool {
        var adjacent: Int = 0
        var down: Bool = true
        var i = 1
        while down {
            if adjacent >= 3 {
                winner = player
                return true
            }
            if row - i >= 0 && grid[column][row - i] == player {
                adjacent += 1
                i += 1
            } else {down = false}
        }
        return false
    }
    
    func horizontalWin(player: Int, column: Int, row: Int) -> Bool{
        var adjacent: Int = 0
        var left: Bool = true
        var right: Bool = true
        var iLeft = 1
        var iRight = 1
        while left || right {
            if adjacent >= 3 {
                winner = player
                return true
            }
            // left
            if left && column - iLeft >= 0 && grid[column - iLeft][row] == player {
                adjacent += 1
                iLeft += 1
            } else { left = false }
            // right
            if right && column + iRight < columns && grid[column + iRight][row] == player {
                adjacent += 1
                iRight += 1
            } else { right = false }
        }
        return false
    }
    
    func diagonalPositiveWin(player: Int, column: Int, row: Int) -> Bool{
        var adjacent: Int = 0
        var up: Bool = true
        var down: Bool = true
        var iUp = 1
        var iDown = 1
        while up || down {
            if adjacent >= 3 {
                winner = player
                return true
            }
            // down
            if down && column - iDown >= 0 && row - iDown >= 0 && grid[column - iDown][row - iDown] == player {
                adjacent += 1
                iDown += 1
            } else { down = false }
            // up
            if up && column + iUp < columns && row + iUp < rows && grid[column + iUp][row + iUp] == player {
                adjacent += 1
                iUp += 1
            } else { up = false}
        }
        return false
    }
    
    func diagonalNegativeWin(player: Int, column: Int, row: Int) -> Bool {
        var adjacent: Int = 0
        var up: Bool = true
        var down: Bool = true
        var iUp = 1
        var iDown = 1
        while up || down {
            if adjacent >= 3 {
                winner = player
                return true
            }
            // down
            if down && column + iDown < columns && row - iDown >= 0 && grid[column + iDown][row - iDown] == player {
                adjacent += 1
                iDown += 1
            } else { down = false }
            // up
            if up && column - iUp >= 0 && row + iUp < rows && grid[column - iUp][row + iUp] == player {
                adjacent += 1
                iUp += 1
            } else { up = false}
        }
        return false
    }
    
}
