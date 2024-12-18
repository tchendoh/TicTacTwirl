//
//  Player.swift
//  TicTacTwirl
//
//  Created by Eric Chandonnet on 2024-12-05.
//

import Foundation

struct Player {
    enum Theme {
        case violet
        case jinx
    }

    var team: Game.Team = .notPickedYet
    var theme: Theme
    var isReady: Bool = false
    var isGettingReady: Bool = false
    var score: Int = 0

    mutating func setAsGettingReady() {
        isGettingReady = true
    }
    
    mutating func setAsNotGettingReady() {
        isGettingReady = false
    }

    mutating func setAsReady() {
        isReady = true
    }

    mutating func setAsNotReady() {
        isReady = false
    }
}

struct PlayerMove {
    let squarePosition: SquarePosition
    let player: Player
}
