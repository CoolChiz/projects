//
//  model.swift
//  assign1
//
//  Created by Duy on 9/7/21.
//

import Foundation

struct Tile: Equatable{
    var val: Int
    var id: Int = -1
    var lastRow = 0, lastCol = 0
    init(v: Int) {
        val = v
    }
    static func == (tile1: Tile, tile2: Tile) -> Bool {
        return tile1.val == tile2.val
    }
}

struct Score: Hashable {
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}

enum Direction {
    case left
    case right
    case up
    case down
}

class Twos: ObservableObject{
    @Published var board: [[Tile]]
    @Published var score: Int
    @Published var tileList: [Tile]
    @Published var scoreList: [Score]
    @Published var coin: String = "Heads"
    var seededGenerator: SeededGenerator
    var ids: Int = 0
    init() {
        board = [[Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)]]
        score = 0
        seededGenerator = SeededGenerator(seed: UInt64(Int.random(in: 1...1000)))
        tileList = []

        scoreList = [Score(score: 400, time: Date(timeIntervalSinceReferenceDate: -1000)), Score(score: 300, time: Date(timeIntervalSinceReferenceDate: -1000))]
    }
    
    func shiftLeft() {
        var newBoard: [[Tile]] = [[Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                                  [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                                  [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                                  [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)]]
        let xLength = board.count
        let yLength = board[0].count
        for x in 0..<xLength {
            var leftIndex = 0
            var prevTile: Tile?
            for y in 0..<yLength {
                let boardTile = board[x][y]
                if(boardTile.val != 0) {
                    if(prevTile == nil) { // if prevValue has a value
                        prevTile = boardTile
                    } else {
                        if(prevTile == boardTile) {
                            newBoard[x][leftIndex] = boardTile
                            newBoard[x][leftIndex].val = prevTile!.val + boardTile.val
                            score += prevTile!.val + boardTile.val
                            leftIndex = leftIndex + 1
                            prevTile = nil
                        } else {
                            newBoard[x][leftIndex] = prevTile!
                            newBoard[x][leftIndex].val = prevTile!.val
                            leftIndex = leftIndex + 1
                            prevTile = boardTile
                        }
                    }
                }
            }
            if(prevTile != nil) { // Fills the left-most empty tile
                newBoard[x][leftIndex] = prevTile!
            }
        }
        board = newBoard
    }
    func rightRotate() {
        board = rotate2D(input: board)
    }
    
    func updateTileList() {
        for x in 0..<self.board.count {
            for y in 0..<self.board[x].count {
                // Updates IDs with new values
                if(board[x][y].val != 0) {
                    let tileIndex = findTileIndex(tile: board[x][y])
                    tileList[tileIndex].val = board[x][y].val
                    tileList[tileIndex].lastRow = x
                    tileList[tileIndex].lastCol = y
                }
            }
        }
        // Remove replaced tiles
       removeDeletedtiles()
    }
    
    func findTileIndex(tile: Tile) -> Int {
        var ans: Int = 0
        for i in (0..<self.tileList.count) {
            if(tileList[i].id == tile.id) {
                ans = i
                break
            }
        }
        return ans
    }
    
    func findTileIndexInBoard(tile: Tile) -> Bool {
        var ans: Bool = false
        for x in 0..<self.board.count {
            for y in 0..<self.board[x].count {
                if(board[x][y].id == tile.id) {
                    ans = true
                    break
                }
            }
        }
        return ans
    }
    
    func removeDeletedtiles(){
        for i in 0..<tileList.count {
            if(findTileIndexInBoard(tile: tileList[i]) == false) {
                tileList[i].id = -1
            }
        }
    }
    

    
    func collapse(dir: Direction) -> Bool {
        let temp: [[Tile]] = board
        switch dir {
        case Direction.left:
            self.shiftLeft()
        case Direction.right:
            self.rightRotate()
            self.rightRotate()
            self.shiftLeft()
            self.rightRotate()
            self.rightRotate()
        case Direction.up:
            self.rightRotate()
            self.rightRotate()
            self.rightRotate()
            self.shiftLeft()
            self.rightRotate()
        case Direction.down:
            self.rightRotate()
            self.shiftLeft()
            self.rightRotate()
            self.rightRotate()
            self.rightRotate()
        }
        updateTileList()
        if(temp == board) {
            return false
        } else {
            return true
        }
    }
    
    func newgame(rand: Bool) {
        self.board = [[Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)]]
        self.scoreList.append(Score(score: self.score, time: Date()))
        self.scoreList.sort{$0.score > $1.score}
        self.score = 0
        self.tileList = []
        if(rand == true) {
            seededGenerator = SeededGenerator(seed: UInt64(Int.random(in: 1...1000)))
        } else {
            seededGenerator = SeededGenerator(seed: 14)
        }
    }
    
    func spawn() {
        let placedNumber = (Int.random(in: 0...1, using: &seededGenerator) == 0 ? 2 : 4)
        let emptyTiles: [(Int, Int)] = emptyTiles(board: self.board)
        let selectedTile = Int.random(in: 0..<emptyTiles.count, using: &seededGenerator)
        let xCoord = emptyTiles[selectedTile].0
        let yCoord = emptyTiles[selectedTile].1
        board[xCoord][yCoord] = Tile(v:placedNumber)
        board[xCoord][yCoord].id = ids
        ids += 1
        board[xCoord][yCoord].lastRow = xCoord
        board[xCoord][yCoord].lastCol = yCoord
        self.tileList.append(board[xCoord][yCoord])
    }
    
    func emptyTiles(board: [[Tile]]) -> [(Int, Int)] {
        var emptyTiles: [(Int, Int)] = []
        for x in 0..<board.count {
            for y in 0..<board[0].count {
                if(board[x][y].val == 0) {
                    emptyTiles.append((x, y))
                }
            }
        }
        return emptyTiles
    }
    
    func isGameOver() -> Bool {
        for x in 0..<board.count {
            for y in 0..<board[0].count {
                if(board[x][y].val == 0) {
                    return false
                } else if (x != board.count - 1 && board[x][y] == board[x + 1][y]) {
                    return false
                } else if (y != board.count - 1 && board[x][y] == board[x][y + 1]) {
                    return false
                }
            }
        }
        return true
    }
    
    func flipCoin() {
        coin = (Int.random(in: 0...1, using: &seededGenerator) == 0 ? "Heads": "Tails")
    }
}



public func rotate2DInts(input: [[Int]]) ->[[Int]] {
    var newArr: [[Int]] = input
    let xLength = input.count
    let yLength = input[0].count
    for x in 0..<xLength {
        for y in 0..<yLength {
            newArr[y][xLength - 1 - x] = input[x][y]
        }
    }
    return newArr
}

public func rotate2D<T>(input: [[T]]) ->[[T]] {
    var newArr: [[T]] = input
    let xLength = input.count
    let yLength = input[0].count
    for x in 0..<xLength {
        for y in 0..<yLength {
            newArr[y][xLength - 1 - x] = input[x][y]
        }
    }
    return newArr
}
