//
//  model.swift
//  assign1
//
//  Created by Duy on 9/7/21.
//

import Foundation

struct Tile: Equatable{
    var val: Int
    var lastRow = 0, lastCol = 0
    init(v: Int) {
        val = v
    }
    static func ==(tile1: Tile, tile2: Tile) -> Bool {
        return tile1.val == tile2.val
    }
}

enum Direction {
    case left
    case right
    case up
    case down
}

class Twos {
    var board: [[Tile]]
    
    init() {
        board = [[Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)],
                 [Tile(v:0), Tile(v:0), Tile(v:0), Tile(v:0)]]
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
            var prevValue: Int?
            for y in 0..<yLength {
                let boardValue = board[x][y].val
                if(boardValue != 0) {
                    if(prevValue == nil) { // if prevValue has a value
                        prevValue = boardValue
                    } else {
                        if(prevValue == boardValue) {
                            newBoard[x][leftIndex].val = prevValue! + boardValue
                            leftIndex = leftIndex + 1
                            prevValue = nil
                        } else {
                            newBoard[x][leftIndex].val = prevValue!
                            leftIndex = leftIndex + 1
                            prevValue = boardValue
                        }
                    }
                }
            }
            if(prevValue != nil) { // Fills the left-most empty tile
                newBoard[x][leftIndex].val = prevValue!
            }
        }
        board = newBoard
    }
    
    func rightRotate() {
        board = rotate2D(input: board)
    }
    
    func collapse(dir: Direction) {
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
