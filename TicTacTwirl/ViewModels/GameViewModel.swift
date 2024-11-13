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
    
    func areBothPlayersReady() -> Bool {
        game.areBothPlayersReady()
    }

    func areBothPlayersGettingReady() -> Bool {
        game.areBothPlayersGettingReady()
    }

    func setTopPlayerAsReady() {
        game.player1.setAsReady()
        if areBothPlayersReady() {
            startGame()
        }
    }
    
    func setBottomPlayerAsReady() {
        game.player2.setAsReady()
        if game.areBothPlayersReady() {
            startGame()
        }
    }
    
    func setTopPlayerAsNotReady() {
        game.player1.setAsNotReady()
    }
    
    func setBottomPlayerAsNotReady() {
        game.player2.setAsNotReady()
    }

    func setTopPlayerAsGettingReady() {
        game.player1.setAsGettingReady()
    }

    func setBottomPlayerAsGettingReady() {
        game.player2.setAsGettingReady()
    }

    func setTopPlayerAsNotGettingReady() {
        game.player1.setAsNotGettingReady()
    }
    
    func setBottomPlayerAsNotGettingReady() {
        game.player2.setAsNotGettingReady()
    }
    
    func makeMove(position: SquarePosition) {
        game.makeMove(position: position)
    }
}
