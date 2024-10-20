//
//  Game.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
//

import Foundation

enum SquarePosition: CaseIterable {
    case topLeft
    case topMiddle
    case topRight
    case middleLeft
    case middle
    case middleRight
    case bottomLeft
    case bottomMiddle
    case bottomRight
}

struct Player {
    var team: Game.Team = .notPickedYet
    var score: Int = 0
}

struct PlayerMove {
    let squarePosition: SquarePosition
    var mark: SquareValue
}

struct Game {
    enum Status {
        case teamPicking
        case gameOn
        case gameOver
    }
    
    enum Team {
        case x, o
        case notPickedYet
    }

    enum Turn {
        case x
        case o
        
        func getMark() -> SquareValue {
            switch self {
            case .x:
                return .x
            case .o:
                return .o
            }
        }
        
        func getExpiringMark() -> SquareValue {
            switch self {
            case .x:
                return .expiringO
            case .o:
                return .expiringX
            }
        }
        
        mutating func toggle() {
            switch self {
            case .x:
                self = .o
            case .o:
                self = .x
            }
        }
    }

    var board: [SquarePosition:SquareValue] = [:]
    var status: Status = .teamPicking
    var turn: Turn = .x
    var currentMarks: [PlayerMove] = []
    var winningLine: [SquarePosition] = []
    var playerTop: Player = Player()
    var playerBottom: Player  = Player()

    init() {
        createBoard()
    }
    
    mutating func createBoard() {
        for position in SquarePosition.allCases {
            board[position] = .empty
        }
    }
    
    mutating func startGame() {
        assignRandomTeamsToPlayers()
        status = .gameOn
    }

    
    mutating func assignRandomTeamsToPlayers() {
        let shuffledTeams = [Team.x, Team.o].shuffled()
        
        playerTop.team = shuffledTeams[0]
        playerBottom.team = shuffledTeams[1]
    }

    mutating func makeMove(at: SquarePosition) {
        placeNewMark(position: at)
        
        if detectWin() {
            status = .gameOver
        }
        else {
            expireOldMark()
            turn.toggle()
        }
    }

    mutating func placeNewMark(position: SquarePosition) {
        board[position] = turn.getMark()
        currentMarks.append(PlayerMove(squarePosition: position, mark: turn.getMark()))

    }

    mutating func expireOldMark() {
        if currentMarks.count > 6 {
            let removedMark = currentMarks.removeFirst()
            board[removedMark.squarePosition] = .empty
        }
        if currentMarks.count > 5 {
            board[currentMarks[0].squarePosition] = turn.getExpiringMark()
        }
    }
    
    mutating func detectWin() -> Bool {
        guard currentMarks.count > 4 else {
            return false
        }
        // Horizontal (3)
        if (turn.getMark() == board[.topLeft] &&
            turn.getMark() == board[.topMiddle] &&
            turn.getMark() == board[.topRight]) {
            winningLine = [.topLeft, .topMiddle, .topRight]
        }
        else if (turn.getMark() == board[.middleLeft] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.middleRight]) {
            winningLine = [.middleLeft, .middle, .middleRight]
        }
        else if (turn.getMark() == board[.bottomLeft] &&
                 turn.getMark() == board[.bottomMiddle] &&
                 turn.getMark() == board[.bottomRight]) {
            winningLine = [.bottomLeft, .bottomMiddle, .bottomRight]
        }
        // Vertical (3)
        else if (turn.getMark() == board[.topLeft] &&
                 turn.getMark() == board[.middleLeft] &&
                 turn.getMark() == board[.bottomLeft]) {
            winningLine = [.topLeft, .middleLeft, .bottomLeft]
        }
        else if (turn.getMark() == board[.topMiddle] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.bottomMiddle]) {
            winningLine = [.topMiddle, .middle, .bottomMiddle]
        }
        else if (turn.getMark() == board[.topRight] &&
                 turn.getMark() == board[.middleRight] &&
                 turn.getMark() == board[.bottomRight]) {
            winningLine = [.topRight, .middleRight, .bottomRight]
        }
        // Diagonal (2)
        else if (turn.getMark() == board[.topLeft] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.bottomRight]) {
            winningLine = [.topLeft, .middle, .bottomRight]
        }
        else if (turn.getMark() == board[.topRight] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.bottomLeft]) {
            winningLine = [.topRight, .middle, .bottomLeft]
        }
        
        if !winningLine.isEmpty {
            return true
        }
        return false
    }
    
}
