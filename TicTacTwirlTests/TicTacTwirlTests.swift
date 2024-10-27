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

        XCTAssertTrue(game.board.count == 9, "Board should have 9 squares.")
    }

    func test_Game_InitialState_ShouldBeInTeamPickingStatus() throws {
        let game = Game()

        XCTAssertTrue(game.status == .teamPicking, "Game should start in teamPicking status.")
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

        XCTAssert(xCount > 400 && xCount < 600)
        XCTAssert(oCount > 400 && oCount < 600)
    }

    func test_Game_StartGame_ShouldChangeStatusToGameOn() throws {
        var game = Game()
        game.startGame()

        XCTAssert(game.status == .gameOn)
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
        game.player2.setAsReady()
        XCTAssertTrue(game.areBothPlayersReady())
    }

    // MARK: Tests des mouvements
    func test_Game_MakeMove_ShouldPlaceCorrectMark() throws {
        var game = Game()
        game.makeMove(position: .bottomLeft)

        XCTAssertNotNil(game.board[.bottomLeft])
        XCTAssertTrue(game.board[.bottomLeft] == .xMark)
    }

    func test_Game_MakeMove_ShouldToggleTurn() throws {
        var game = Game()
        XCTAssertTrue(game.turn.getMark() == .xMark)
        game.makeMove(position: .bottomRight)
        XCTAssertTrue(game.turn.getMark() == .oMark)
        game.makeMove(position: .topLeft)
        XCTAssertTrue(game.turn.getMark() == .xMark)
    }

    func test_Game_MakeMove_ShouldRecordToCurrentMarks() throws {
        var game = Game()
        let squarePosition: SquarePosition = .topMiddle
        game.makeMove(position: squarePosition)

        XCTAssertTrue(game.currentMarks.first?.mark == .xMark)
        XCTAssertTrue(game.currentMarks.first?.squarePosition == squarePosition)
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
        XCTAssertTrue(unwrappedMark == .xMark)

        game.makeMove(position: .topLeft)
        unwrappedMark = try XCTUnwrap(game.board[firstPosition])
        XCTAssertTrue(unwrappedMark == .expiringX)
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
        XCTAssertTrue(unwrappedMark == .empty)
        XCTAssertTrue(game.currentMarks.count == 6)
    }

    // MARK: Détection de victoire, huit possiblités
    func test_Game_ThreeHorizontalMarks1_ShouldDetectWin() throws {
        var game = Game()
        game.makeMove(position: .topLeft)
        game.makeMove(position: .bottomLeft)
        game.makeMove(position: .topMiddle)
        game.makeMove(position: .bottomMiddle)
        game.makeMove(position: .topRight)
        XCTAssertTrue(game.status == .gameOver) // Est-ce que ça devrait être un test séparé?
        XCTAssertTrue(game.winningLine.contains(.topLeft)) // Est-ce que ça devrait être un test séparé?
        XCTAssertTrue(game.winningLine.contains(.topMiddle))
        XCTAssertTrue(game.winningLine.contains(.topRight))
    }
    func test_Game_ThreeHorizontalMarks2_ShouldDetectWin() throws {
    }
    func test_Game_ThreeHorizontalMarks3_ShouldDetectWin() throws {
    }
    func test_Game_ThreeVerticalMarks1_ShouldDetectWin() throws {
    }
    func test_Game_ThreeVerticalMarks2_ShouldDetectWin() throws {
    }
    func test_Game_ThreeVerticalMarks3_ShouldDetectWin() throws {
    }
    func test_Game_ThreeDiagonalMarks1_ShouldDetectWin() throws {
    }
    func test_Game_ThreeDiagonalMarks2_ShouldDetectWin() throws {
    }

    func test_Game_WinningMove_ShouldSetGameOverStatus() throws {
    }

    func test_Game_WinningMove_ShouldSetCorrectWinningLine() throws {
    }
}
