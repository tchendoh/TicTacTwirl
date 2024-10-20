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
    var playerTop: Player {
        game.playerTop
    }
    var playerBottom: Player {
        game.playerBottom
    }
    var winningLine: [SquarePosition] {
        game.winningLine
    }


    init() {
        game = Game()
    }
    
    func startGame() {
        game.startGame()
    }
    
    func makeMove(at: SquarePosition)
    {
        game.makeMove(at: at)
    }
}
