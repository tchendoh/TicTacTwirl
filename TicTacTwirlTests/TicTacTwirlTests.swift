//
//  TicTacTwirlTests.swift
//  TicTacTwirlTests
//
//  Created by Eric Chandonnet on 2024-10-16.
//

import XCTest
@testable import TicTacTwirl

final class TicTacTwirlTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    // MARK: Tests d'initialisation et de statut de jeu
    func test_Game_InitialState_ShouldHaveEmptyBoard() throws {
        let game = Game()

        XCTAssertEqual(game.board.count, 9, "Board should always have 9 squares.")
    }

    func test_Game_InitialState_ShouldBeInTeamPickingStatus() throws {
        let game = Game()

        XCTAssertEqual(game.status, .teamPicking, "Game should start in teamPicking status.")
    }

    func test_Game_InitialState_ShouldHavePlayersNotReady() throws {
        let game = Game()

        XCTAssertFalse(game.player1.isReady)
        XCTAssertFalse(game.player2.isReady)
    }
    func test_Game_StartGame_ShouldAssignTeamsRandomlyForPlayer1() throws {
        var xCount = 0
        var oCount = 0

        var game = Game()

        for _ in 0..<1000 {
            game.assignRandomTeamsToPlayers()
            if game.player1.team == .xMark {
                xCount += 1
            } else if game.player1.team == .oMark {
                oCount += 1
            }
        }

        XCTAssert(xCount > 400 && xCount < 600)
        XCTAssert(oCount > 400 && oCount < 600)
    }

    func test_Game_StartGame_ShouldAssignTeamsRandomlyForPlayer2() throws {
        var xCount = 0
        var oCount = 0

        var game = Game()

        for _ in 0..<1000 {
            game.assignRandomTeamsToPlayers()
            if game.player2.team == .xMark {
                xCount += 1
            } else if game.player2.team == .oMark {
                oCount += 1
            }
        }

        XCTAssertGreaterThan(xCount, 400)
        XCTAssertGreaterThan(oCount, 400)
        XCTAssertLessThan(xCount, 600)
        XCTAssertLessThan(oCount, 600)
    }

    func test_Game_StartGame_ShouldChangeStatusToGameOn() throws {
        var game = Game()
        game.startGame()

        XCTAssertEqual(game.status, .gameOn)
    }

    // MARK: Tests de gestion des joueurs
    func test_Player1_SetAsReady_ShouldUpdateReadyStatus() throws {
        var game = Game()
        XCTAssertFalse(game.player1.isReady)
        game.player1.setAsReady()
        XCTAssertTrue(game.player1.isReady)
    }

    func test_Player2_SetAsReady_ShouldUpdateReadyStatus() throws {
        var game = Game()
        XCTAssertFalse(game.player2.isReady)
        game.player2.setAsReady()
        XCTAssertTrue(game.player2.isReady)
    }

    func test_Player1_SetAsNotReady_ShouldUpdateReadyStatus() throws {
        var game = Game()
        game.player1.setAsReady()
        game.player1.setAsNotReady()
        XCTAssertFalse(game.player1.isReady)
    }

    func test_Player2_SetAsNotReady_ShouldUpdateReadyStatus() throws {
        var game = Game()
        game.player2.setAsReady()
        game.player2.setAsNotReady()
        XCTAssertFalse(game.player2.isReady)
    }

    func test_Game_StartGame_ShouldKnowWhenBothPlayersAreReady() throws {
        var game = Game()

        game.player1.setAsReady()
        XCTAssertFalse(game.areBothPlayersReady())

        game.player2.setAsReady()
        XCTAssertTrue(game.areBothPlayersReady())
    }

    // MARK: Tests des mouvements
    func test_Game_MakeMove_ShouldPlaceCorrectMark() throws {
        var game = Game()
        game.makeMove(position: .bottomLeft)

        XCTAssertNotNil(game.board[.bottomLeft])
        XCTAssertEqual(game.board[.bottomLeft], .xMark)
    }

    func test_Game_MakeMove_ShouldToggleTurn() throws {
        var game = Game()
        XCTAssertEqual(game.turn.getMark(), .xMark)
        game.makeMove(position: .bottomRight)
        XCTAssertEqual(game.turn.getMark(), .oMark)
        game.makeMove(position: .topLeft)
        XCTAssertEqual(game.turn.getMark(), .xMark)
    }

    func test_Game_MakeMove_ShouldRecordToCurrentMarks() throws {
        var game = Game()
        let squarePosition: SquarePosition = .topMiddle
        game.makeMove(position: squarePosition)

        XCTAssertEqual(game.currentMarks.first?.mark, .xMark)
        XCTAssertEqual(game.currentMarks.first?.squarePosition, squarePosition)
    }

    func test_Game_SixthMove_ShouldGiveFirstMarkExpiringStatus() throws {
        var game = Game()
        let firstPosition: SquarePosition = .bottomRight
        game.makeMove(position: firstPosition)
        game.makeMove(position: .middleRight)
        game.makeMove(position: .topRight)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .middleLeft)

        var unwrappedMark = try XCTUnwrap(game.board[firstPosition])
        XCTAssertEqual(unwrappedMark, .xMark)

        game.makeMove(position: .topLeft)
        unwrappedMark = try XCTUnwrap(game.board[firstPosition])
        XCTAssertEqual(unwrappedMark, .expiringX)
    }

    func test_Game_SeventhMove_ShoulExpireFirstMark() throws {
        var game = Game()
        let firstPosition: SquarePosition = .bottomRight
        game.makeMove(position: firstPosition)
        game.makeMove(position: .middleRight)
        game.makeMove(position: .topRight)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .middleLeft)
        game.makeMove(position: .topLeft)
        game.makeMove(position: .middle)
        let unwrappedMark = try XCTUnwrap(game.board[firstPosition])
        XCTAssertEqual(unwrappedMark, .empty)
        XCTAssertEqual(game.currentMarks.count, 6)
    }

    // MARK: Détection de victoire, huit possiblités
    func test_Game_ThreeHorizontalMarks1_ShouldDetectWin() throws {
        //        x | x | x
        //       -----------
        //          |   |
        //       -----------
        //        o | o |

        var game = Game()
        game.makeMove(position: .topLeft)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .topRight)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.topLeft))
        XCTAssertTrue(game.winningLine.contains(.topMiddle))
        XCTAssertTrue(game.winningLine.contains(.topRight))
    }

    func test_Game_ThreeHorizontalMarks2_ShouldDetectWin() throws {
        //          |   |
        //       -----------
        //        x | x | x
        //       -----------
        //        o | o |

        var game = Game()
        game.makeMove(position: .middleLeft)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .middle)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .middleRight)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.middleLeft))
        XCTAssertTrue(game.winningLine.contains(.middle))
        XCTAssertTrue(game.winningLine.contains(.middleRight))
    }

    func test_Game_ThreeHorizontalMarks3_ShouldDetectWin() throws {
        //        x | x |
        //       -----------
        //          | x |
        //       -----------
        //        o | o | o

        var game = Game()
        game.makeMove(position: .topLeft)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .middle)
        game.makeMove(position: .bottomRight)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.bottomLeft))
        XCTAssertTrue(game.winningLine.contains(.bottomMiddle))
        XCTAssertTrue(game.winningLine.contains(.bottomRight))
    }

    func test_Game_ThreeVerticalMarks1_ShouldDetectWin() throws {
        //        x | o |
        //       -----------
        //        x |   |
        //       -----------
        //        x | o |

        var game = Game()
        game.makeMove(position: .topLeft)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .middleLeft)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .bottomLeft)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.topLeft))
        XCTAssertTrue(game.winningLine.contains(.middleLeft))
        XCTAssertTrue(game.winningLine.contains(.bottomLeft))
    }
    func test_Game_ThreeVerticalMarks2_ShouldDetectWin() throws {
        //        x | o |
        //       -----------
        //          | o | x
        //       -----------
        //        x | o |

        var game = Game()
        game.makeMove(position: .topLeft)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .middleRight)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .middle)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.topMiddle))
        XCTAssertTrue(game.winningLine.contains(.bottomMiddle))
        XCTAssertTrue(game.winningLine.contains(.middle))
    }
    func test_Game_ThreeVerticalMarks3_ShouldDetectWin() throws {
        //          | o | x
        //       -----------
        //          |   | x
        //       -----------
        //          | o | x

        var game = Game()
        game.makeMove(position: .topRight)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .middleRight)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .bottomRight)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.topRight))
        XCTAssertTrue(game.winningLine.contains(.middleRight))
        XCTAssertTrue(game.winningLine.contains(.bottomRight))
    }
    func test_Game_ThreeDiagonalMarks1_ShouldDetectWin() throws {
        //          | o | x
        //       -----------
        //          | x |
        //       -----------
        //        x | o |

        var game = Game()
        game.makeMove(position: .topRight)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .middle)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .bottomLeft)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.topRight))
        XCTAssertTrue(game.winningLine.contains(.middle))
        XCTAssertTrue(game.winningLine.contains(.bottomLeft))
    }
    func test_Game_ThreeDiagonalMarks2_ShouldDetectWin() throws {
        //        o |   | x
        //       -----------
        //          | o |
        //       -----------
        //        x | x | o

        var game = Game()
        game.makeMove(position: .topRight)
        game.makeMove(position: .topLeft)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .middle)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .bottomRight)
        XCTAssertEqual(game.status, .gameOver)
        XCTAssertTrue(game.winningLine.contains(.topLeft))
        XCTAssertTrue(game.winningLine.contains(.middle))
        XCTAssertTrue(game.winningLine.contains(.bottomRight))
    }

    func test_Game_WinningMove_ShouldSetGameOverStatus() throws {
    }

    func test_Game_WinningMove_ShouldSetCorrectWinningLine() throws {
    }
}
