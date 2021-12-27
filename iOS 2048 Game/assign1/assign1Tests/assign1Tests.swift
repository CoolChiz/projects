//
//  assign1Tests.swift
//  assign1Tests
//
//  Created by Pete Keleher on 2/2/20.
//  Updated by Shoumit Karnik on 1/20/21.
//  Copyright © 2020 PeteWorks. All rights reserved.
//

import XCTest
@testable import assign1

class assign1Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func int2tile(iboard : [[Int]]) -> [[Tile]] {
        var b : [[Tile]] = Array(repeating: Array(repeating: Tile(v: 0), count: iboard.count), count: iboard.count)

        for i in 0..<iboard.count {
            for j in 0..<iboard.count {
                b[i][j].val = iboard[i][j]
            }
        }
        return b
    }
    
    func testSetup() {
        let game = Twos()
        XCTAssertTrue((game.board.count == 4) && (game.board[3].count == 4))
    }

    func testRotate1() {
        var board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        board = rotate2DInts(input: board)
        XCTAssertTrue(board == [[3,0,1,0],[3,2,2,3],[6,1,3,3],[6,3,3,3]])
    }

    func testRotate2() {
        var board = [["0","3","3","3"],["1","2","3","3"],["0","2","1","3"],["3","3","6","6"]]
        board = rotate2D(input: board)
        XCTAssertTrue(board == [["3","0","1","0"],["3","2","2","3"],["6","1","3","3"],["6","3","3","3"]])
    }

    func testShift() {
        let game = Twos()
        game.board = int2tile(iboard: [[0,2,2,2],[4,2,4,4],[0,8,2,4],[0,0,4,4]])
        game.shiftLeft()
        XCTAssertTrue(game.board == int2tile(iboard: [[4,2,0,0],[4,2,8,0],[8,2,4,0],[8,0,0,0]]))
    }

    func testLeft() {
        let game = Twos()
        game.board = int2tile(iboard: [[0,2,2,2],[4,2,4,4],[0,8,2,4],[0,0,4,4]])
        game.collapse(dir: .left)
        XCTAssertTrue(game.board == int2tile(iboard: [[4,2,0,0],[4,2,8,0],[8,2,4,0],[8,0,0,0]]))
    }

    func testRight() {
        let game = Twos()
        game.board = int2tile(iboard: [[0,2,2,2],[4,2,4,4],[0,8,2,4],[0,0,4,4]])
       game.collapse(dir: .right)
        XCTAssertTrue(game.board == int2tile(iboard: [[0,0,2,4],[0,4,2,8],[0,8,2,4],[0,0,0,8]]))

    }

    func testDown() {
        let game = Twos()
        game.board = int2tile(iboard: [[0,2,2,2],[4,2,4,4],[0,8,2,4],[0,0,4,4]])
        game.collapse(dir: .down)
        XCTAssertTrue(game.board == int2tile(iboard: [[0,0,2,0],[0,0,4,2],[0,4,2,4],[4,8,4,8]]))
    }

    func testUp() {
        let game = Twos()
        game.board = int2tile(iboard: [[0,2,2,2],[4,2,4,4],[0,8,2,4],[0,0,4,4]])
        game.collapse(dir: .up)
        XCTAssertTrue(game.board == int2tile(iboard: [[4,4,2,2],[0,8,4,8],[0,0,2,4],[0,0,4,0]]))
    }

}
