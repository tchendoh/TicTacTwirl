//
//  GameViewModel.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
//

import Foundation
import Observation

@Observable class GameViewModel {
    var game: Game
    var gameStatus: Game.Status {
        game.status
    }
    var turn: Game.Turn {
        game.turn
    }
    var winningLine: [SquarePosition] {
        game.winningLine
    }
    var player1: Player {
        game.player1
    }
    var player2: Player {
        game.player2
    }

    init() {
        game = Game()
    }
    
    func startGame() {
        game.startGame()
    }
    
    func setTopPlayerAsReady() {
        game.player1.setAsReady()
        if areBothPlayersReady() {
            startGame()
        }
    }

    func setBottomPlayerAsReady() {
        game.player2.setAsReady()
        if areBothPlayersReady() {
            startGame()
        }
    }

    func setTopPlayerAsNotReady() {
        game.player1.setAsNotReady()
    }
    
    func setBottomPlayerAsNotReady() {
        game.player2.setAsNotReady()
    }

    private func areBothPlayersReady() -> Bool {
        player1.isReady && player2.isReady
    }
    
    func makeMove(position: SquarePosition) {
        game.makeMove(position: position)
    }
}
